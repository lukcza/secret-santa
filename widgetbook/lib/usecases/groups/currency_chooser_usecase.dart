import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:secret_santa/features/groups/presentation/widgets/currency _chooser.dart';

final currencyChooserComponent = WidgetbookComponent(
  name: 'CurrencyChooser',
  useCases: [
    WidgetbookUseCase(
      name: 'Default (EUR)',
      builder: (context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Select Currency',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              CurrencyChooser(),
            ],
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'With Search',
      builder: (context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Search for currency',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                'Try typing "USD", "EUR", "PLN"',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              CurrencyChooser(),
            ],
          ),
        ),
      ),
    ),
  ],
);
