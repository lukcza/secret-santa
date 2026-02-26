import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:secret_santa/features/home/presentation/widgets/active_exchanges_card.dart';

final activeExchangesCardComponent = WidgetbookComponent(
  name: 'ActiveExchangesCard',
  useCases: [
    WidgetbookUseCase(
      name: 'No Exchanges',
      builder: (context) => const Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16),
          child: ActiveExchangesCard(countActiveExchanges: 0),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Single Exchange',
      builder: (context) => const Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16),
          child: ActiveExchangesCard(countActiveExchanges: 1),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Multiple Exchanges',
      builder: (context) => const Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16),
          child: ActiveExchangesCard(countActiveExchanges: 5),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Many Exchanges',
      builder: (context) => const Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16),
          child: ActiveExchangesCard(countActiveExchanges: 12),
        ),
      ),
    ),
  ],
);
