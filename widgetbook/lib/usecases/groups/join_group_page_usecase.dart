import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_santa/core/enums/group_status.dart';
import 'package:secret_santa/core/enums/user_status.dart';
import 'package:secret_santa/features/groups/domain/entities/group_entity.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_bloc.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_event.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_state.dart';
import 'package:secret_santa/features/groups/presentation/pages/join/join_group_page.dart';
import 'package:widgetbook/widgetbook.dart';

final _sampleGroup = GroupEntity(
  id: 'group_santa_2026',
  title: 'North Pole Party 🎄',
  description: 'Annual Secret Santa gift exchange for elves!',
  authorUID: 'elf_boss',
  participants: const {
    'elf_boss': UserStatus.creator,
    'user_123': UserStatus.confirmed,
  },
  participantsUIDs: const ['elf_boss', 'user_123'],
  budgetLimit: 50,
  currency: 'PLN',
  eventDate: DateTime(2026, 12, 24),
  createdAt: DateTime(2026, 11, 1),
  inviteCode: 'SANTA2026',
  state: GroupStatus.draft,
);

class _FakeGroupBloc extends Bloc<GroupEvent, GroupState> implements GroupBloc {
  _FakeGroupBloc(super.initialState) {
    on<JoinGroupByInviteCodeEvent>((event, emit) {
      emit(state.copyWith(joinStatus: JoinGroupStatus.success, group: _sampleGroup));
    });
  }
}

Widget _wrapJoinGroupPage(GroupState state, {String? initialInviteCode}) {
  return BlocProvider<GroupBloc>(
    create: (_) => _FakeGroupBloc(state),
    child: Navigator(
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (_) => JoinGroupPage(initialInviteCode: initialInviteCode),
      ),
    ),
  );
}

final joinGroupPageUseCase = WidgetbookComponent(
  name: 'JoinGroupPage',
  useCases: [
    WidgetbookUseCase(
      name: '① Initial State (Empty Code)',
      builder: (context) {
        return _wrapJoinGroupPage(
          const GroupState(joinStatus: JoinGroupStatus.initial),
        );
      },
    ),
    WidgetbookUseCase(
      name: '② Pre-filled Invite Code & Found Group',
      builder: (context) {
        return _wrapJoinGroupPage(
          GroupState(
            joinStatus: JoinGroupStatus.initial,
            group: _sampleGroup,
          ),
          initialInviteCode: 'SANTA2026',
        );
      },
    ),
    WidgetbookUseCase(
      name: '③ Loading State (Joining...)',
      builder: (context) {
        return _wrapJoinGroupPage(
          const GroupState(joinStatus: JoinGroupStatus.loading),
          initialInviteCode: 'SANTA2026',
        );
      },
    ),
    WidgetbookUseCase(
      name: '④ Error State (Invalid Code)',
      builder: (context) {
        final errorMsg = context.knobs.string(
          label: 'Error Message',
          initialValue: 'Group with provided code not found',
        );
        return _wrapJoinGroupPage(
          GroupState(
            joinStatus: JoinGroupStatus.error,
            errorMessage: errorMsg,
          ),
          initialInviteCode: 'INVALID99',
        );
      },
    ),
  ],
);
