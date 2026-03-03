import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:secret_santa/features/groups/presentation/widgets/group_budget_slider.dart';

final groupBudgetSliderComponent = WidgetbookComponent(
  name: 'GroupBudgetSlider',
  useCases: [
    WidgetbookUseCase(
      name: 'Low Budget (10)',
      builder:
          (context) => Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Budget: \$10',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  GroupBudgetSlider(
                    budget: 10,
                    onChanged: (double value) {},
                    minLimitText: '\$0',
                    maxLimitText: '\$1000',
                    budgetText: 'Budget limit',
                    controller: TextEditingController(text: '10'),
                  ),
                ],
              ),
            ),
          ),
    ),
    WidgetbookUseCase(
      name: 'Medium Budget (50)',
      builder:
          (context) => Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Budget: \$50',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  GroupBudgetSlider(
                    budget: 50,
                    onChanged: (double value) {},
                    minLimitText: '\$0',
                    maxLimitText: '\$1000',
                    budgetText: 'Budget limit',
                    controller: TextEditingController(text: '50'),
                  ),
                ],
              ),
            ),
          ),
    ),
    WidgetbookUseCase(
      name: 'High Budget (100)',
      builder:
          (context) => Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Budget: \$100',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  GroupBudgetSlider(
                    budget: 100,
                    onChanged: (double value) {},
                    minLimitText: '\$0',
                    maxLimitText: '\$1000',
                    budgetText: 'Budget limit',
                    controller: TextEditingController(text: '100'),
                  ),
                ],
              ),
            ),
          ),
    ),
  ],
);
