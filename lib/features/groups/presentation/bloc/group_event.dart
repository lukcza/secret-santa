import 'package:equatable/equatable.dart';
import 'package:secret_santa/features/groups/domain/entities/group_entity.dart';
import 'package:secret_santa/features/wishlist/domain/entities/wishlist_item_entity.dart';

abstract class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object?> get props => [];
}

// ── Wishlist events ──────────────────────────────────────────────────────────

class LoadGroupWishlistEvent extends GroupEvent {
  final String uid;
  final String groupId;

  const LoadGroupWishlistEvent({required this.uid, required this.groupId});

  @override
  List<Object?> get props => [uid, groupId];
}

class AddWishlistItemEvent extends GroupEvent {
  final String uid;
  final String groupId;
  final WishlistItemEntity item;

  const AddWishlistItemEvent({
    required this.uid,
    required this.groupId,
    required this.item,
  });

  @override
  List<Object?> get props => [uid, groupId, item];
}

class RemoveWishlistItemEvent extends GroupEvent {
  final String uid;
  final String groupId;
  final String itemId;

  const RemoveWishlistItemEvent({
    required this.uid,
    required this.groupId,
    required this.itemId,
  });

  @override
  List<Object?> get props => [uid, groupId, itemId];
}

class CreateGroupEvent extends GroupEvent {
  final GroupEntity group;

  const CreateGroupEvent({required this.group});

  @override
  List<Object?> get props => [group];
}

class JoinGroupEvent extends GroupEvent {
  final String groupCode;

  const JoinGroupEvent({required this.groupCode});

  @override
  List<Object?> get props => [groupCode];
}

class LeaveGroupEvent extends GroupEvent {
  final String groupId;

  const LeaveGroupEvent({required this.groupId});

  @override
  List<Object?> get props => [groupId];
}

class UpdateGroupEvent extends GroupEvent {
  final GroupEntity group;

  const UpdateGroupEvent(this.group);

  @override
  List<Object?> get props => [group];
}

class GenerateInviteCodeEvent extends GroupEvent {
  const GenerateInviteCodeEvent();

  @override
  List<Object?> get props => [];
}

class GetGroupParticipantsEvent extends GroupEvent {
  final String groupId;

  const GetGroupParticipantsEvent({required this.groupId});

  @override
  List<Object?> get props => [groupId];
}

/// Losuje pary lokalnie (bez zapisu do bazy).
class DrawPairsLocalEvent extends GroupEvent {
  final List<String> participantUids;
  final Map<String, List<String>> excludedPairs;

  const DrawPairsLocalEvent({
    required this.participantUids,
    this.excludedPairs = const {},
  });

  @override
  List<Object?> get props => [participantUids, excludedPairs];
}

/// Zatwierdza wylosowane pary i zapisuje do bazy.
class ConfirmDrawEvent extends GroupEvent {
  final GroupEntity group;
  final Map<String, String> matches;

  const ConfirmDrawEvent({required this.group, required this.matches});

  @override
  List<Object?> get props => [group, matches];
}
