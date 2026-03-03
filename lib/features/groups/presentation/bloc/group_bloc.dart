import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_santa/core/enums/group_status.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_event.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_state.dart';
import 'package:secret_santa/features/home/domain/usecases/create_group.dart';
import 'package:secret_santa/features/home/domain/usecases/generate_group_code.dart';
import 'package:secret_santa/features/home/domain/usecases/join_group.dart';
import 'package:secret_santa/features/home/domain/usecases/leave_group.dart';
import 'package:secret_santa/features/home/domain/usecases/update_group.dart';
class GroupBloc extends Bloc<GroupEvent, GroupState> {
  GroupBloc({
    required JoinGroup joinGroup,
    required CreateGroup createGroup,
    required LeaveGroup leaveGroup,
    required UpdateGroup updateGroup,
    required GenerateGroupCode generateGroupCode,
  }) : super(GroupState(status: GroupStatus.draft)) {
    on<CreateGroupEvent>((event, emit) {
      emit(state.copyWith(status: GroupStatus.draft));
      final result = createGroup(
        event.group
      );
    });
    on<JoinGroupEvent>((event, emit) async {
      final result = await joinGroup(event.groupCode);
      result.fold(
        (failure) {
          emit(state.copyWith(
            joinStatus: JoinGroupStatus.error,
            errorMessage: failure.message,
          ));
        },
        (_) {
          emit(state.copyWith(joinStatus: JoinGroupStatus.success));
        },
      );
    });
    on<LeaveGroupEvent>((event, emit) {
        final result = leaveGroup(event.groupId);
        emit(state.copyWith(joinStatus: JoinGroupStatus.left));
    });
    on<UpdateGroupEvent>((event, emit) {
      // Handle update group logic here
    });
  }
}
