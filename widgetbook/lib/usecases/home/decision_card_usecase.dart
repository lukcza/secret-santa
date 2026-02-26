import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:secret_santa/features/home/presentation/widgets/decision_card.dart';

final decisionCardComponent = WidgetbookComponent(
  name: 'DecisionCard',
  useCases: [
    WidgetbookUseCase(
      name: 'Primary (Create)',
      builder: (context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: DecisionCard(
            title: 'Utwórz losowanie',
            description: 'Stwórz nową grupę Secret Santa',
            buttonText: 'Utwórz',
            cardType: true,
            onTap: () => print("Create card tapped"),
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Secondary (Join)',
      builder: (context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: DecisionCard(
            title: 'Dołącz do losowania',
            description: 'Użyj kodu zaproszenia aby dołączyć',
            buttonText: 'Dołącz',
            cardType: false,
            onTap: () => print("Join card tapped"),
          ),
        ),
      ),
    ),
  ],
);
