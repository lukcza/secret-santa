import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_secret_santa/usecases/groups/create_group_page_component.dart';
import 'group_name_field_usecase.dart';
import 'group_budget_slider_usecase.dart';
import 'currency_chooser_usecase.dart';
import 'manually_invite_page_usecase.dart';

final groupsDirectory = WidgetbookFolder(
  name: 'Groups',
  children: [
    groupNameFieldComponent,
    groupBudgetSliderComponent,
    currencyChooserComponent,
    createGroupPageComponent,
    manuallyInvitePageComponent,
  ],
);
