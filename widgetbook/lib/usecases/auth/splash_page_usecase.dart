import 'package:flutter/material.dart';
import 'package:secret_santa/features/auth/presentation/pages/splash_page.dart';
import 'package:widgetbook/widgetbook.dart';

final splashPageComponent = WidgetbookComponent(
  name: 'SplashPage',
  useCases: [
    WidgetbookUseCase(
      name: '① Default Splash Screen',
      builder: (context) => const SplashPage(),
    ),
  ],
);
