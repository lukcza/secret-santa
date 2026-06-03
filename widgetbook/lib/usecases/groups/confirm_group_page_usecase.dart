import 'package:flutter/material.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';
import 'package:secret_santa/features/groups/presentation/pages/create/confirm_group_page.dart';
import 'package:widgetbook/widgetbook.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_bloc.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_event.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_state.dart';
import 'package:secret_santa/core/enums/group_status.dart';

class FakeGroupBloc extends Bloc<GroupEvent, GroupState> implements GroupBloc {
  FakeGroupBloc() : super(GroupState(status: GroupStatus.draft));
}

final confirmGroupPageComponent = WidgetbookComponent(
  name: 'ConfirmGroupPage',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) {
        return BlocProvider<GroupBloc>(
          create: (_) => FakeGroupBloc(),
          child: ConfirmGroupPage(
            groupName: 'North Pole Party',
            budget: 25,
            date: DateTime(DateTime.now().year, 12, 24),
            authorUID: 'admin_uid',
            currency: 'USD',
            participants: [
              UserEntity(
                uid: 'admin_uid',
                email: 'santa@northpole.com',
                nickname: 'You (Admin)',
                avatarBgColorValue: const Color(0xFF3D1515).toARGB32(),
                avatarForegroundColorValue: const Color(0xFFD32F2F).toARGB32(),
              ),
              UserEntity(
                uid: 'jane_uid',
                email: 'jane.doe@example.com',
                nickname: 'Jane Doe',
                avatarBgColorValue: const Color(0xFF161F3D).toARGB32(),
                avatarForegroundColorValue: const Color(0xFF5C6BC0).toARGB32(),
              ),
              UserEntity(
                uid: 'robert_uid',
                email: 'frosty@winter.com',
                nickname: 'Robert Frost',
                avatarBgColorValue: const Color(0xFF0F261B).toARGB32(),
                avatarForegroundColorValue: const Color(0xFF4CAF50).toARGB32(),
                avatarIconCodePoint: Icons.face_retouching_natural.codePoint,
              ),
              UserEntity(
                uid: 'mary_uid',
                email: 'mary.kringle@example.com',
                nickname: 'Mary Kringle',
                avatarBgColorValue: const Color(0xFF38230F).toARGB32(),
                avatarForegroundColorValue: const Color(0xFFFFA726).toARGB32(),
              ),
              UserEntity(
                uid: 'tim_uid',
                email: 'timothy@cratchit.co',
                nickname: 'Tim Tiny',
                avatarBgColorValue: const Color(0xFF301525).toARGB32(),
                avatarForegroundColorValue: const Color(0xFFEC407A).toARGB32(),
                avatarIconCodePoint: Icons.face_3.codePoint,
              ),
            ],
            onConfirm: () {},
            onAddMore: () {},
            onEditOrder: () {},
            onEditGroup: () {},
          ),
        );
      },
    ),
  ],
);
