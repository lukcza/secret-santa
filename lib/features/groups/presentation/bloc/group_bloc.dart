import 'dart:math' as math;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_santa/core/enums/group_status.dart';

import 'package:secret_santa/features/groups/domain/usecases/get_groups_participants.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_event.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_state.dart';
import 'package:secret_santa/features/groups/domain/usecases/create_group.dart';
import 'package:secret_santa/features/groups/domain/usecases/generate_group_code.dart';
import 'package:secret_santa/features/groups/domain/usecases/join_group.dart';
import 'package:secret_santa/features/groups/domain/usecases/leave_group.dart';
import 'package:secret_santa/features/groups/domain/usecases/update_group.dart';
import 'package:secret_santa/features/groups/domain/usecases/get_group_wishlist.dart';
import 'package:secret_santa/features/groups/domain/usecases/add_wishlist_item.dart';
import 'package:secret_santa/features/groups/domain/usecases/remove_wishlist_item.dart';
import 'package:secret_santa/features/wishlist/domain/entities/wishlist_item_entity.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  GroupBloc({
    required JoinGroup joinGroup,
    required CreateGroup createGroup,
    required LeaveGroup leaveGroup,
    required UpdateGroup updateGroup,
    required GenerateGroupCode generateGroupCode,
    required GetGroupsParticipants getGroupsParticipants,
    required GetGroupWishlist getGroupWishlist,
    required AddWishlistItem addWishlistItem,
    required RemoveWishlistItem removeWishlistItem,
  }) : super(GroupState(status: GroupStatus.draft)) {
    on<LoadGroupWishlistEvent>((event, emit) async {
      emit(state.copyWith(wishlistLoading: true));
      final result = await getGroupWishlist(uid: event.uid, groupId: event.groupId);
      result.fold(
        (failure) => emit(state.copyWith(wishlistLoading: false, errorMessage: failure.message)),
        (items) => emit(state.copyWith(wishlistLoading: false, myGroupWishlist: items)),
      );
    });
    on<AddWishlistItemEvent>((event, emit) async {
      final optimistic = List<WishlistItemEntity>.from(state.myGroupWishlist)
        ..add(event.item);
      emit(state.copyWith(myGroupWishlist: optimistic));
      final result = await addWishlistItem(
        uid: event.uid,
        groupId: event.groupId,
        item: event.item,
      );
      result.fold(
        (failure) {
          // rollback
          final rolled = List<WishlistItemEntity>.from(state.myGroupWishlist)
            ..removeWhere((i) => i.id == event.item.id);
          emit(state.copyWith(myGroupWishlist: rolled, errorMessage: failure.message));
        },
        (_) {/* already optimistically updated */},
      );
    });
    on<RemoveWishlistItemEvent>((event, emit) async {
      final optimistic = state.myGroupWishlist
          .where((i) => i.id != event.itemId)
          .toList();
      emit(state.copyWith(myGroupWishlist: optimistic));
      final result = await removeWishlistItem(
        uid: event.uid,
        groupId: event.groupId,
        itemId: event.itemId,
      );
      result.fold(
        (failure) => emit(state.copyWith(errorMessage: failure.message)),
        (_) {/* already removed optimistically */},
      );
    });
    on<JoinGroupEvent>((event, emit) async {
      final result = await joinGroup(event.groupCode);
      result.fold(
        (failure) {
          emit(
            state.copyWith(
              joinStatus: JoinGroupStatus.error,
              errorMessage: failure.message,
            ),
          );
        },
        (_) {
          emit(state.copyWith(joinStatus: JoinGroupStatus.success));
        },
      );
    });
    on<LeaveGroupEvent>((event, emit) async {
      final result = await leaveGroup(event.groupId);
      emit(state.copyWith(joinStatus: JoinGroupStatus.left));
    });
    on<CreateGroupEvent>((event, emit) async {
      emit(state.copyWith(status: GroupStatus.draft));
      final result = await createGroup(event.group);
      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: GroupStatus.error,
              errorMessage: failure.message,
            ),
          );
        },
        (createdGroup) {
          emit(state.copyWith(status: GroupStatus.drawn, group: createdGroup));
        },
      );
    });
    on<UpdateGroupEvent>((event, emit) async {
      final result = await updateGroup(event.group);
      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: GroupStatus.error,
              errorMessage: failure.message,
            ),
          );
        },
        (_) {
          emit(state.copyWith(status: GroupStatus.drawn, group: event.group));
        },
      );
    });
    on<GenerateInviteCodeEvent>((event, emit) {
      const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
      final random = math.Random();
      final code = String.fromCharCodes(
        Iterable.generate(
          6,
          (_) => chars.codeUnitAt(random.nextInt(chars.length)),
        ),
      );
      emit(state.copyWith(inviteCode: code));
    });
    on<GetGroupParticipantsEvent>((event, emit) async {
      final result = await getGroupsParticipants(event.groupId);
      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: GroupStatus.error,
              errorMessage: failure.message,
            ),
          );
        },
        (participants) {
          emit(state.copyWith(participants: participants));
        },
      );
    });
    on<DrawPairsLocalEvent>((event, emit) {
      final participants = event.participantUids;
      final excluded = event.excludedPairs;
      if (participants.length < 3) {
        emit(
          state.copyWith(
            status: GroupStatus.error,
            errorMessage: 'Too few participants (minimum 3)',
          ),
        );
        return;
      }
      emit(
        GroupState(
          group: state.group,
          joinStatus: state.joinStatus,
          status: GroupStatus.loading,
          inviteCode: state.inviteCode,
          participants: state.participants,
          matches: const {},
        ),
      );

      // Sprawdź czy istnieje chociaż jedno poprawne przypisanie
      if (!_hasValidAssignment(participants, excluded)) {
        emit(
          state.copyWith(
            status: GroupStatus.error,
            errorMessage: 'Too many exclusions – no valid draw is possible',
          ),
        );
        return;
      }

      Map<String, String>? matches;
      for (int attempt = 0; attempt < 100; attempt++) {
        final shuffled = List<String>.from(participants)
          ..shuffle(math.Random());
        final draft = <String, String>{};
        bool valid = true;
        for (int i = 0; i < participants.length; i++) {
          final giver = participants[i];
          final recipient = shuffled[i];
          if (giver == recipient ||
              (excluded[giver]?.contains(recipient) ?? false)) {
            valid = false;
            break;
          }
          draft[giver] = recipient;
        }
        if (valid && draft.length == participants.length) {
          matches = draft;
          break;
        }
      }

      if (matches == null) {
        emit(
          state.copyWith(
            status: GroupStatus.error,
            errorMessage: 'Failed to draw pairs – please try again',
          ),
        );
        return;
      }
      emit(state.copyWith(status: GroupStatus.drawn, matches: matches));
    });

    on<ConfirmDrawEvent>((event, emit) async {
      final updatedGroup = event.group.copyWith(matches: event.matches);
      final result = await updateGroup(updatedGroup);
      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: GroupStatus.error,
              errorMessage: failure.message,
            ),
          );
        },
        (_) {
          emit(
            state.copyWith(
              status: GroupStatus.drawn,
              group: updatedGroup,
              matches: event.matches,
            ),
          );
        },
      );
    });
  }
}

/// Sprawdza (backtracking z early exit) czy istnieje chociaż jedno
/// poprawne przypisanie darówca → odbiorca bez naruszeń reguł.
/// Zwraca [true] przy pierwszym znalezionym rozwiązaniu.
bool _hasValidAssignment(
  List<String> participants,
  Map<String, List<String>> excluded,
) {
  bool found = false;
  final remaining = List<String>.from(participants);

  void backtrack(int idx) {
    if (found) return; // early exit
    if (idx == participants.length) {
      found = true;
      return;
    }
    final giver = participants[idx];
    for (int j = 0; j < remaining.length; j++) {
      final recipient = remaining[j];
      if (giver == recipient) continue;
      if (excluded[giver]?.contains(recipient) ?? false) continue;
      remaining.removeAt(j);
      backtrack(idx + 1);
      remaining.insert(j, recipient);
      if (found) return;
    }
  }

  backtrack(0);
  return found;
}
