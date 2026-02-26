import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

final themeDirectory = WidgetbookFolder(
  name: 'Theme',
  children: [
    WidgetbookComponent(
      name: 'Colors',
      useCases: [
        WidgetbookUseCase(
          name: 'Color Palette',
          builder: (context) => Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, 'Primary Colors'),
                  _colorTile('Primary', Theme.of(context).colorScheme.primary),
                  _colorTile('On Primary', Theme.of(context).colorScheme.onPrimary),
                  const SizedBox(height: 16),
                  _buildSectionTitle(context, 'Secondary Colors'),
                  _colorTile('Secondary', Theme.of(context).colorScheme.secondary),
                  _colorTile('On Secondary', Theme.of(context).colorScheme.onSecondary),
                  const SizedBox(height: 16),
                  _buildSectionTitle(context, 'Tertiary Colors'),
                  _colorTile('Tertiary', Theme.of(context).colorScheme.tertiary),
                  const SizedBox(height: 16),
                  _buildSectionTitle(context, 'Surface Colors'),
                  _colorTile('Surface', Theme.of(context).colorScheme.surface),
                  _colorTile('On Surface', Theme.of(context).colorScheme.onSurface),
                  const SizedBox(height: 16),
                  _buildSectionTitle(context, 'Error Colors'),
                  _colorTile('Error', Theme.of(context).colorScheme.error),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'Typography',
      useCases: [
        WidgetbookUseCase(
          name: 'Text Styles',
          builder: (context) => Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, 'Display'),
                  Text('Display Large', style: Theme.of(context).textTheme.displayLarge),
                  Text('Display Medium', style: Theme.of(context).textTheme.displayMedium),
                  Text('Display Small', style: Theme.of(context).textTheme.displaySmall),
                  const SizedBox(height: 24),
                  _buildSectionTitle(context, 'Headline'),
                  Text('Headline Large', style: Theme.of(context).textTheme.headlineLarge),
                  Text('Headline Medium', style: Theme.of(context).textTheme.headlineMedium),
                  Text('Headline Small', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 24),
                  _buildSectionTitle(context, 'Title'),
                  Text('Title Large', style: Theme.of(context).textTheme.titleLarge),
                  Text('Title Medium', style: Theme.of(context).textTheme.titleMedium),
                  Text('Title Small', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 24),
                  _buildSectionTitle(context, 'Body'),
                  Text('Body Large', style: Theme.of(context).textTheme.bodyLarge),
                  Text('Body Medium', style: Theme.of(context).textTheme.bodyMedium),
                  Text('Body Small', style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 24),
                  _buildSectionTitle(context, 'Label'),
                  Text('Label Large', style: Theme.of(context).textTheme.labelLarge),
                  Text('Label Medium', style: Theme.of(context).textTheme.labelMedium),
                  Text('Label Small', style: Theme.of(context).textTheme.labelSmall),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
    WidgetbookComponent(
      name: 'Buttons',
      useCases: [
        WidgetbookUseCase(
          name: 'All Button Types',
          builder: (context) => Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSectionTitle(context, 'Elevated Button'),
                  ElevatedButton(onPressed: () {}, child: const Text('Elevated Button')),
                  const SizedBox(height: 16),
                  _buildSectionTitle(context, 'Filled Button'),
                  FilledButton(onPressed: () {}, child: const Text('Filled Button')),
                  const SizedBox(height: 16),
                  _buildSectionTitle(context, 'Outlined Button'),
                  OutlinedButton(onPressed: () {}, child: const Text('Outlined Button')),
                  const SizedBox(height: 16),
                  _buildSectionTitle(context, 'Text Button'),
                  TextButton(onPressed: () {}, child: const Text('Text Button')),
                  const SizedBox(height: 16),
                  _buildSectionTitle(context, 'Icon Button'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(onPressed: () {}, icon: const Icon(Icons.favorite)),
                      IconButton.filled(onPressed: () {}, icon: const Icon(Icons.favorite)),
                      IconButton.outlined(onPressed: () {}, icon: const Icon(Icons.favorite)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  ],
);

Widget _buildSectionTitle(BuildContext context, String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    ),
  );
}

Widget _colorTile(String name, Color color) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade400),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name),
              Text(
                '#${color.value.toRadixString(16).toUpperCase().padLeft(8, '0')}',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
