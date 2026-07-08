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

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  GroupBloc({
    required JoinGroup joinGroup,
    required CreateGroup createGroup,
    required LeaveGroup leaveGroup,
    required UpdateGroup updateGroup,
    required GenerateGroupCode generateGroupCode,
    required GetGroupsParticipants getGroupsParticipants,
  }) : super(GroupState(status: GroupStatus.draft)) {
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
    on<DrawPairsEvent>((event, emit) async {
      final result = await drawPairs(event.groupId);
      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: GroupStatus.error,
              errorMessage: failure.message,
            ),
          );
        },
        (matches) {
          emit(state.copyWith(matches: matches));
        },
      );
    });
  }
}
