import 'package:secret_santa/features/home/domain/usecases/create_group.dart';
import 'package:secret_santa/features/home/domain/usecases/generate_group_code.dart';
import 'package:secret_santa/features/home/domain/usecases/get_group_by_id.dart';
import 'package:secret_santa/features/home/domain/usecases/get_group_code.dart';
import 'package:secret_santa/features/home/domain/usecases/get_user_groups.dart';
import 'package:secret_santa/features/home/domain/usecases/join_group.dart';
import 'package:secret_santa/features/home/domain/usecases/leave_group.dart';
import 'package:secret_santa/features/home/domain/usecases/update_group.dart';
import 'package:secret_santa/features/home/presentation/bloc/home_event.dart';
import 'package:secret_santa/features/home/presentation/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class HomeBloc extends Bloc<HomeEvent, HomeState>{
  HomeBloc({
    required  JoinGroup joinGroup,
    required  GetUserGroups getUserGroups,
  }) : super(const HomeState()) {
    on<HomeGetUserGroupsEvent>((event, emit) async {
      final result = await getUserGroups();
      result.fold(
        (failure) {
          emit(state.copyWith(
            status: HomeStatus.error,
            errorMessage: failure.message,
          ));
        },
        (groups) {
          emit(state.copyWith(
            status: HomeStatus.loaded,
            groups: groups,
          ));
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