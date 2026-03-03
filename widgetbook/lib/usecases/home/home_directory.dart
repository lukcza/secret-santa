import 'package:widgetbook/widgetbook.dart';

import 'active_exchanges_card_usecase.dart';
import 'bottom_nav_bar_usecase.dart';
import 'decision_card_usecase.dart';
import 'group_list_item_usecase.dart';
import 'add_group_placeholder_usecase.dart';
import 'sorting_type_slider_usecase.dart';
import 'home_page_usecase.dart';

final homeDirectory = WidgetbookFolder(
  name: 'Home',
  children: [
    activeExchangesCardComponent,
    bottomNavBarComponent,
    decisionCardComponent,
    groupListItemComponent,
    addGroupPlaceholderComponent,
    sortingTypeSliderComponent,
    homePageComponent,
  ],
);
