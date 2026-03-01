import 'package:equatable/equatable.dart';
import 'package:secret_santa/features/home/domain/entities/group_entity.dart';

abstract class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object?> get props => [];
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
  
  const UpdateGroupEvent({required this.group});

  @override
  List<Object?> get props => [group];
}
