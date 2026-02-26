import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_santa/core/extensions/context_extension.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:secret_santa/features/home/presentation/bloc/home_bloc.dart';
import 'package:secret_santa/features/home/presentation/bloc/home_event.dart';
import 'package:secret_santa/features/home/presentation/bloc/home_state.dart';
import 'package:secret_santa/features/home/presentation/widgets/active_exchanges_card.dart';
import 'package:secret_santa/features/home/presentation/widgets/add_group_placeholder.dart';
import 'package:secret_santa/features/home/presentation/widgets/bottom_nav_bar.dart';
import 'package:secret_santa/features/home/presentation/widgets/group_list_item.dart';
import 'package:secret_santa/features/home/presentation/widgets/sorting_type_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late UserEntity user;
  @override
  void initState() {
    super.initState();
    user = context.read<AuthBloc>().state.user!;
    context.read<HomeBloc>().add(HomeGetUserGroupsEvent());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: IconButton(
          //TODO: add navigation to notifications page
          onPressed:() => print("notfication button clicked"), 
          icon: Icon(
            Icons.notifications,
            color: Theme.of(context).colorScheme.tertiary,
            )
          ),
        title: Text(context.loc.homeTitle),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 5),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                onPressed: () => print("profile button clicked"),
                icon: const Icon(
                    Icons.person,
                    color: Colors.grey,
                  ),
              ),
            ),
          )
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return SafeArea(
            child: Container(
              margin: const EdgeInsets.only(left: 5, right: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                    ActiveExchangesCard(countActiveExchanges: state.groups.length ?? 0,),
                    SortingTypeSlider(),
                    AddGroupPlaceholder(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.groups.length,
                        itemBuilder: (context, index) {
                          final group = state.groups[index];
                          return BlocSelector<HomeBloc, HomeState, GroupListItem>(
                            selector: (state) => GroupListItem(group: group, user: user),
                            builder: (context, groupListItem) {
                              return groupListItem;
                            },
                          );
                        },
                      ),
                    )
                  ],
              ),
            ),
          );
        }
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0, onTap: (index) => print("navigation button clicked with index: $index")),
    );
  }
}