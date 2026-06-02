import 'package:equatable/equatable.dart';
import 'package:secret_santa/core/enums/group_status.dart';
import 'package:secret_santa/features/home/domain/entities/group_entity.dart';
enum JoinGroupStatus { initial, loading, success, error, left }
class GroupState extends Equatable {
  final JoinGroupStatus joinStatus;
  final GroupStatus status;
  final String? errorMessage;
  final GroupEntity? group;
  final String? inviteCode;
  const GroupState({
    this.group,
    this.joinStatus = JoinGroupStatus.initial,
    this.status = GroupStatus.draft,
    this.errorMessage,
    this.inviteCode,
  });

  GroupState copyWith({
    GroupEntity? group,
    GroupStatus? status,
    String? errorMessage,
    JoinGroupStatus? joinStatus,
    String? inviteCode,
  }) {
    return GroupState(
      group: group ?? this.group,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      joinStatus: joinStatus ?? this.joinStatus,
      inviteCode: inviteCode ?? this.inviteCode,
    );
  }
  @override
  List<Object?> get props => [group, status, errorMessage, joinStatus, inviteCode];
}