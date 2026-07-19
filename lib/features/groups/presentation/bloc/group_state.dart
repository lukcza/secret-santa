import 'package:equatable/equatable.dart';
import 'package:secret_santa/core/enums/group_status.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';
import 'package:secret_santa/features/groups/domain/entities/group_entity.dart';

enum JoinGroupStatus { initial, loading, success, error, left }

class GroupState extends Equatable {
  final JoinGroupStatus joinStatus;
  final GroupStatus status;
  final String? errorMessage;
  final GroupEntity? group;
  final String? inviteCode;
  final List<UserEntity> participants;
  final Map<String, String> matches;
  const GroupState({
    this.group,
    this.joinStatus = JoinGroupStatus.initial,
    this.status = GroupStatus.draft,
    this.errorMessage,
    this.inviteCode,
    this.participants = const [],
    this.matches = const {},
  });

  GroupState copyWith({
    GroupEntity? group,
    GroupStatus? status,
    String? errorMessage,
    JoinGroupStatus? joinStatus,
    String? inviteCode,
    List<UserEntity>? participants,
    Map<String, String>? matches,
  }) {
    return GroupState(
      group: group ?? this.group,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      joinStatus: joinStatus ?? this.joinStatus,
      inviteCode: inviteCode ?? this.inviteCode,
      participants: participants ?? this.participants,
      matches: matches ?? this.matches,
    );
  }

  @override
  List<Object?> get props => [
    group,
    status,
    errorMessage,
    joinStatus,
    inviteCode,
    participants,
    matches,
  ];
}
