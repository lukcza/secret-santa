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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BottomNavigationBar(
          currentIndex: widget.currentIndex,
          onTap: (index) {
            widget.onTap(index);
            _showNavigationFeedback(context, index);
            _navigateToRoute(context, index);
          },
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: context.loc.home,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: context.loc.profile,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.notifications),
              label: context.loc.notifications,
            ),
          ],
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
        context.go('/profile');
        break;
      case 2:
        context.go('/notifications');
        break;
    }
  }

  void _showNavigationFeedback(BuildContext context, int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 300),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: const SizedBox.shrink(),
      ),
    );
  }
}