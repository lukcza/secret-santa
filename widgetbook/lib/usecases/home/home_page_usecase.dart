import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:secret_santa/features/home/presentation/widgets/active_exchanges_card.dart';
import 'package:secret_santa/features/home/presentation/widgets/add_group_placeholder.dart';
import 'package:secret_santa/features/home/presentation/widgets/bottom_nav_bar.dart';
import 'package:secret_santa/features/home/presentation/widgets/group_list_item.dart';
import 'package:secret_santa/features/home/presentation/widgets/sorting_type_slider.dart';
import 'package:secret_santa/features/home/domain/entities/group_entity.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';
import 'package:secret_santa/core/enums/group_state.dart';

final homePageComponent = WidgetbookComponent(
  name: 'HomePage',
  useCases: [
    WidgetbookUseCase(
      name: 'Empty State',
      builder: (context) => _HomePagePreview(groups: const []),
    ),
    WidgetbookUseCase(
      name: 'With Groups',
      builder: (context) => _HomePagePreview(
        groups: [
          _mockGroup('Christmas 2024', GroupState.recruiting),
          _mockGroup('Office Party', GroupState.active),
          _mockGroup('Family Exchange', GroupState.draft),
        ],
      ),
    ),
    WidgetbookUseCase(
      name: 'Many Groups',
      builder: (context) => _HomePagePreview(
        groups: List.generate(
          8,
          (i) => _mockGroup('Group ${i + 1}', GroupState.values[i % GroupState.values.length]),
        ),
      ),
    ),
  ],
);

class _HomePagePreview extends StatelessWidget {
  const _HomePagePreview({required this.groups});
  
  final List<GroupEntity> groups;

  @override
  Widget build(BuildContext context) {
    final user = _mockUser();
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.notifications,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        title: const Text('Home'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 5),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.person,
                  color: Colors.grey,
                ),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 5, right: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ActiveExchangesCard(countActiveExchanges: groups.length),
              SortingTypeSlider(),
              AddGroupPlaceholder(),
              Expanded(
                child: groups.isEmpty
                    ? Center(
                        child: Text(
                          'No groups yet',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.grey,
                              ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: groups.length,
                        itemBuilder: (context, index) {
                          return GroupListItem(
                            group: groups[index],
                            user: user,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {},
      ),
    );
  }
}

UserEntity _mockUser() => const UserEntity(
      uid: 'user123',
      email: 'santa@northpole.com',
      nickname: 'Santa Claus',
      photoUrl: null,
      groups: ['group1', 'group2'],
      wishlist: ['gift1', 'gift2'],
    );

GroupEntity _mockGroup(String title, GroupState state) => GroupEntity(
      id: 'group_${title.hashCode}',
      title: title,
      description: 'Gift exchange event',
      authorUID: 'author123',
      participantsUIDs: const ['user1', 'user2', 'user3', 'user4'],
      budgetLimit: 50,
      currency: 'PLN',
      eventDate: DateTime(2024, 12, 24),
      createdAt: DateTime.now(),
      inviteCode: 'ABC123',
      state: state,
    );
