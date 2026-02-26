import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:secret_santa/features/home/presentation/widgets/group_list_item.dart';
import 'package:secret_santa/features/home/domain/entities/group_entity.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';
import 'package:secret_santa/core/enums/group_state.dart';

final groupListItemComponent = WidgetbookComponent(
  name: 'GroupListItem',
  useCases: [
    WidgetbookUseCase(
      name: 'Draft State',
      builder: (context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: GroupListItem(
            group: _mockGroup(GroupState.draft),
            user: _mockUser(),
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Recruiting State',
      builder: (context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: GroupListItem(
            group: _mockGroup(GroupState.recruiting),
            user: _mockUser(),
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Drawn State',
      builder: (context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: GroupListItem(
            group: _mockGroup(GroupState.drawn),
            user: _mockUser(),
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Active State',
      builder: (context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: GroupListItem(
            group: _mockGroup(GroupState.active),
            user: _mockUser(),
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Finished State',
      builder: (context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: GroupListItem(
            group: _mockGroup(GroupState.finished),
            user: _mockUser(),
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'As Author',
      builder: (context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: GroupListItem(
            group: _mockGroup(GroupState.recruiting, authorUID: 'user123'),
            user: _mockUser(uid: 'user123'),
          ),
        ),
      ),
    ),
  ],
);

UserEntity _mockUser({String uid = 'mockUser123'}) {
  return UserEntity(
    uid: uid,
    email: 'santa@northpole.com',
    nickname: 'Santa Claus',
    photoUrl: null,
    groups: ['group1', 'group2'],
    wishlist: ['gift1', 'gift2'],
  );
}

GroupEntity _mockGroup(GroupState state, {String authorUID = 'author123'}) {
  return GroupEntity(
    id: 'group123',
    title: 'Christmas Exchange 2024',
    description: 'Annual family gift exchange',
    authorUID: authorUID,
    participantsUIDs: ['user1', 'user2', 'user3', 'user4'],
    budgetLimit: 50,
    currency: 'PLN',
    eventDate: DateTime(2024, 12, 24),
    createdAt: DateTime.now(),
    inviteCode: 'ABC123',
    state: state,
  );
}
