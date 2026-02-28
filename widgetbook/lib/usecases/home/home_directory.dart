import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_secret_santa/usecases/home/create_or_join_page_usecase.dart';
import 'package:widgetbook_secret_santa/usecases/home/home_page_usecase.dart';

import 'active_exchanges_card_usecase.dart';
import 'bottom_nav_bar_usecase.dart';
import 'decision_card_usecase.dart';
import 'group_list_item_usecase.dart';
import 'add_group_placeholder_usecase.dart';
import 'sorting_type_slider_usecase.dart';

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
    createOrJoinPageComponent
  ],
);
