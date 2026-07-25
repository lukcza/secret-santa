import 'package:flutter/material.dart';
import 'package:secret_santa/features/auth/presentation/widgets/login_header_card.dart';
import 'package:widgetbook/widgetbook.dart';

final loginHeaderCardComponent = WidgetbookComponent(
  name: 'LoginHeaderCard',
  useCases: [
    WidgetbookUseCase(
      name: '① Default Header Card',
      builder: (context) => const Scaffold(
        body: SingleChildScrollView(
          child: LoginHeaderCard(),
        ),
      ),
    ),
  ],
);
