import 'package:widgetbook/widgetbook.dart';
import 'group_name_field_usecase.dart';
import 'group_budget_slider_usecase.dart';
import 'currency_chooser_usecase.dart';

final groupsDirectory = WidgetbookFolder(
  name: 'Groups',
  children: [
    groupNameFieldComponent,
    groupBudgetSliderComponent,
    currencyChooserComponent,
  ],
);
