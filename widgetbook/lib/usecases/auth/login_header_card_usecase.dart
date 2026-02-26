import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:secret_santa/features/auth/presentation/widgets/login_header_card.dart';

final loginHeaderCardComponent = WidgetbookComponent(
  name: 'LoginHeaderCard',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => const Scaffold(
        body: SingleChildScrollView(
          child: LoginHeaderCard(),
        ),
      ),
    ),
  ],
);
