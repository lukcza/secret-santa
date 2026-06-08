import 'package:widgetbook/widgetbook.dart';

import 'currency_chooser_usecase.dart';
import 'group_budget_slider_usecase.dart';
import 'group_name_field_usecase.dart';
import 'group_data_card_usecase.dart';
import 'add_friends_list_tile_usecase.dart';
import 'added_counter_usecase.dart';
import 'participant_tile_usecase.dart';
import 'participants_list_usecase.dart';

final groupsWidgetsDirectory = WidgetbookFolder(
  name: 'Widgets',
  children: [
    groupNameFieldComponent,
    groupBudgetSliderComponent,
    currencyChooserComponent,
    groupDataCardComponent,
    addFriendsListTileComponent,
    addedCounterComponent,
    participantTileComponent,
    participantsListComponent,
  ],
);

