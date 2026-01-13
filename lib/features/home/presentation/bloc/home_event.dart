import 'package:equatable/equatable.dart';
import 'package:secret_santa/features/home/data/models/group_model.dart';
import 'package:secret_santa/features/home/domain/entities/group_entity.dart';

abstract class HomeEvent extends Equatable{
  const HomeEvent();

  @override
  List<Object?> get props => [];
}
class HomeGetUserGroupsEvent extends HomeEvent {
  const HomeGetUserGroupsEvent();

  @override
  List<Object?> get props => [];
}
class HomeJoinGroupEvent extends HomeEvent {
  final String groupCode;

  const HomeJoinGroupEvent({required this.groupCode});

  @override
  List<Object?> get props => [groupCode];
}