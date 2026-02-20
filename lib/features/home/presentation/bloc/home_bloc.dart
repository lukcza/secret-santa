import 'package:secret_santa/features/home/data/repositories/group_repository.dart';
import 'package:secret_santa/features/home/domain/usecases/create_group.dart';
import 'package:secret_santa/features/home/domain/usecases/generate_group_code.dart';
import 'package:secret_santa/features/home/domain/usecases/get_group_by_id.dart';
import 'package:secret_santa/features/home/domain/usecases/get_group_code.dart';
import 'package:secret_santa/features/home/domain/usecases/get_user_groups.dart';
import 'package:secret_santa/features/home/domain/usecases/get_user_groups_stream.dart';
import 'package:secret_santa/features/home/domain/usecases/join_group.dart';
import 'package:secret_santa/features/home/domain/usecases/leave_group.dart';
import 'package:secret_santa/features/home/domain/usecases/update_group.dart';
import 'package:secret_santa/features/home/presentation/bloc/home_event.dart';
import 'package:secret_santa/features/home/presentation/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class HomeBloc extends Bloc<HomeEvent, HomeState>{
  HomeBloc({
    required JoinGroup joinGroup,
    required GetUserGroupsStream getUserGroupsStream,
  }) : super(const HomeState()) {
    on<HomeGetUserGroupsEvent>((event, emit) async {
      await emit.forEach(
        getUserGroupsStream(),
        onData: (groups) {
          return state.copyWith(
            status: HomeStatus.loaded,
            userGroups: groups,
          );
        },
        onError: (error, stackTrace) {
          return state.copyWith(
            status: HomeStatus.error,
            errorMessage: error.toString(),
          );
        },
      );
    });
    on<HomeJoinGroupEvent>((event, emit) async {
      emit(state.copyWith(status: HomeStatus.loading));
      final result = await joinGroup(event.groupCode);
      result.fold(
        (failure) {
          emit(state.copyWith(
            status: HomeStatus.error,
            errorMessage: failure.message,
          ));
        },
        (_) {
          add(const HomeGetUserGroupsEvent());
        },
      );
    });
  }
}