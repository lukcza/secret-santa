import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:secret_santa/core/extensions/context_extension.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryFixed,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: MediaQuery.removePadding(
          context: context,
          removeBottom: true,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            backgroundColor: Colors.transparent,
            selectedItemColor: Theme.of(context).colorScheme.secondary,
            currentIndex: widget.currentIndex,
            onTap: (index) {
              widget.onTap(index);
              _navigateToRoute(context, index);
            },
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: context.loc.home,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.notifications),
                label: context.loc.notifications,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person),
                label: context.loc.profile,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToRoute(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/notifications');
        break;
      case 2:
        context.go('/profile');
        break;
    }
  }
}
