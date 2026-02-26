import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:secret_santa/features/home/presentation/widgets/bottom_nav_bar.dart';

final bottomNavBarComponent = WidgetbookComponent(
  name: 'BottomNavBar',
  useCases: [
    WidgetbookUseCase(
      name: 'Home Selected',
      builder: (context) => Scaffold(
        body: const Center(child: Text('Home Content')),
        bottomNavigationBar: BottomNavBar(
          currentIndex: 0,
          onTap: (index) {},
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Notifications Selected',
      builder: (context) => Scaffold(
        body: const Center(child: Text('Notifications Content')),
        bottomNavigationBar: BottomNavBar(
          currentIndex: 1,
          onTap: (index) {},
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Profile Selected',
      builder: (context) => Scaffold(
        body: const Center(child: Text('Profile Content')),
        bottomNavigationBar: BottomNavBar(
          currentIndex: 2,
          onTap: (index) {},
        ),
      ),
    ),
  ],
);
