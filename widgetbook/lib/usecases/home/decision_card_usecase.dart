import 'package:flutter/material.dart';
import 'package:secret_santa/core/extensions/context_extension.dart';
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
            title: context.loc.createNewGroup,
            description: context.loc.createNewGroupDescription,
            buttonText: context.loc.getStarted,
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
            title: context.loc.joinExistingGroup,
            description: context.loc.joinExistingGroupDescription,
            buttonText: context.loc.enterCode,
            cardType: false,
            onTap: () => print("Join card tapped"),
          ),
        ),
      ),
    ),
  ],
);
