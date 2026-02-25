import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:secret_santa/features/home/presentation/bloc/home_bloc.dart';
import 'package:secret_santa/features/home/presentation/bloc/home_event.dart';
import 'package:secret_santa/features/home/presentation/bloc/home_state.dart';
import 'package:secret_santa/features/home/presentation/widgets/active_exchanges_card.dart';
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
    // TODO: implement initState
    super.initState();
    user = context.read<AuthBloc>().state.user!;
    context.read<HomeBloc>().add(HomeGetUserGroupsEvent());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed:() => print("notfication button clicked"), icon: const Icon(Icons.notifications)),
        title: const Text('Gift groups'),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              onPressed: () => print("profile button clicked"),
              icon: const Icon(Icons.person),
            ),
          )
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                  ActiveExchangesCard(countActiveExchanges: state.groups.length,),
                  SortingTypeSlider(),
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
          );
        }
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0, onTap: (index) => print("navigation button clicked with index: $index")),
    );
  }
}