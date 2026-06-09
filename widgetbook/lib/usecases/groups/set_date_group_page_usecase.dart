import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_bloc.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_event.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_state.dart';
import 'package:secret_santa/core/enums/group_status.dart';
import 'package:secret_santa/features/groups/presentation/pages/create/set_date_group_page.dart';
import 'package:widgetbook/widgetbook.dart';

class FakeGroupBloc extends Bloc<GroupEvent, GroupState> implements GroupBloc {
  FakeGroupBloc() : super(const GroupState(status: GroupStatus.draft)) {
    on<GenerateInviteCodeEvent>((event, emit) {
      emit(state.copyWith(inviteCode: 'FAKE42'));
    });
    on<UpdateGroupEvent>((event, emit) {
      emit(state.copyWith(group: event.group));
    });
    on<CreateGroupEvent>((event, emit) {
      emit(state.copyWith(
        status: GroupStatus.drawn,
        group: event.group,
      ));
    });
  }
}

final setDateGroupPageComponent = WidgetbookComponent(
  name: 'SetDateGroupPage',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => BlocProvider<GroupBloc>(
        create: (_) => FakeGroupBloc(),
        child: const SetDateGroupPage(),
      ),
    ),
  ],
);
