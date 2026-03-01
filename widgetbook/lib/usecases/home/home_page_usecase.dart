import 'package:flutter/material.dart';
import 'package:secret_santa/features/home/presentation/pages/home_page.dart';
import 'package:widgetbook/widgetbook.dart';

final homePageComponent = WidgetbookComponent(
  name: 'HomePage',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => const Scaffold(
        body: Center(
          child: Text('HomePage requires AuthBloc & HomeBloc setup'),
        ),
      ),
    ),
  ],
);
