import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:secret_santa/core/enums/group_state.dart';
import 'package:secret_santa/features/home/data/models/group_model.dart';
import 'package:secret_santa/features/home/domain/entities/group_entity.dart';
enum HomeStatus { initial, loading, loaded, error }
class HomeState extends Equatable {
  final HomeStatus status;
  final List<GroupEntity> groups;
  final String? errorMessage;
  const HomeState({
    this.status = HomeStatus.initial,
    this.groups = const [],
    this.errorMessage,
  });
  HomeState copyWith({
    HomeStatus? status,
    List<GroupEntity>? groups,
    String? errorMessage, Object? userGroups,
  }) {
    return HomeState(
      status: status ?? this.status,
      groups: groups ?? this.groups,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
  @override
  List<Object?> get props => [status, groups, errorMessage];
}