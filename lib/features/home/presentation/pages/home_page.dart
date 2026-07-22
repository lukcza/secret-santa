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
      extendBody: true,
      backgroundColor: const Color(0xFF0A150E), // Deep dark green background
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A150E),
        elevation: 0,
        toolbarHeight: 70,
        titleSpacing: 16,
        leadingWidth: 54,
        leading: Container(
          margin: const EdgeInsets.only(left: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF14271B),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                onPressed: () => print("notification button clicked"),
                icon: const Icon(
                  Icons.emoji_events_rounded,
                  color: Color(0xFFD32F2F),
                  size: 20,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFC107),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'HO HO HO!',
              style: TextStyle(
                color: Color(0xFFFFC107),
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
            ),
            Text(
              context.loc.homeTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFFC107), width: 2),
              ),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF1E3A28),
                backgroundImage:
                    user.photoUrl != null && user.photoUrl!.isNotEmpty
                        ? NetworkImage(user.photoUrl!)
                        : null,
                child:
                    user.photoUrl == null || user.photoUrl!.isEmpty
                        ? Text(
                          user.initials,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                        : null,
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          final groups = state.groups;

          return SafeArea(
            bottom: false,
            child: CustomScrollView(
              slivers: [
                // Active Exchanges Header Card
                SliverToBoxAdapter(
                  child: ActiveExchangesCard(
                    countActiveExchanges: groups.length,
                  ),
                ),

                // Sorting / Filtering Categories
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: SortingTypeSlider(),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 8)),

                // Group List
                if (state.status == HomeStatus.loading)
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFD32F2F),
                      ),
                    ),
                  )
                else if (groups.isEmpty)
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.all(24),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF112217),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.card_giftcard_rounded,
                            size: 48,
                            color: Color(0xFFA1B0A6),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'No active exchanges yet',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Create or join a group to start gift sharing!',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final group = groups[index];
                      return GroupListItem(
                        group: group,
                        user: user,
                        onTap: () {
                          // Navigate to group details
                        },
                      );
                    }, childCount: groups.length),
                  ),

                // Bottom Create / Join Group Action Button
                const SliverToBoxAdapter(child: AddGroupPlaceholder()),

                // Padding to allow scrolling under the floating navbar
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) => print("navigation button clicked with index: $index"),
      ),
    );
  }
}
