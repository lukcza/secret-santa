import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_bloc.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_event.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_state.dart';
import 'package:secret_santa/core/enums/group_status.dart';
import 'package:secret_santa/features/groups/presentation/pages/manually_invite_page.dart';
import 'package:widgetbook/widgetbook.dart';

class FakeGroupBloc extends Bloc<GroupEvent, GroupState> implements GroupBloc {
  FakeGroupBloc() : super(GroupState(status: GroupStatus.draft));
}

final manuallyInvitePageComponent = WidgetbookComponent(
  name: 'ManuallyInvitePage',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => BlocProvider<GroupBloc>(
        create: (_) => FakeGroupBloc(),
        child: const ManuallyInvitePage(),
      ),
    ),
  ],
);
