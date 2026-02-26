import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:secret_santa/features/home/presentation/widgets/sorting_type_slider.dart';

final sortingTypeSliderComponent = WidgetbookComponent(
  name: 'SortingTypeSlider',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SortingTypeSlider(),
        ),
      ),
    ),
  ],
);
