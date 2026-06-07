import 'package:secret_santa/features/groups/domain/usecases/get_user_groups_stream.dart';
import 'package:secret_santa/features/home/presentation/bloc/home_event.dart';
import 'package:secret_santa/features/home/presentation/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class HomeBloc extends Bloc<HomeEvent, HomeState>{
  HomeBloc({
    required GetUserGroupsStream getUserGroupsStream,
  }) : super(const HomeState()) {
    on<HomeGetUserGroupsEvent>((event, emit) async {
      await emit.forEach(
        getUserGroupsStream(),
        onData: (groups) {
          return state.copyWith(
            status: HomeStatus.loaded,
            groups: groups,
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
  }
}