import 'package:widgetbook/widgetbook.dart';

import 'create_group_page_component.dart';
import 'manually_invite_page_usecase.dart';
import 'set_date_group_page_usecase.dart';
import 'confirm_group_page_usecase.dart';
import 'details_group_page_usecase.dart';
import 'details_group_split_usecase.dart';
import 'details_participants_page_usecase.dart';
import 'matches_page_usecase.dart';
import 'details_group_hub_usecase.dart';

final groupsPagesDirectory = WidgetbookFolder(
  name: 'Pages',
  children: [
    createGroupPageComponent,
    manuallyInvitePageComponent,
    setDateGroupPageComponent,
    confirmGroupPageComponent,
    detailsGroupPageComponent,
    detailsGroupAdminComponent,
    detailsGroupUserComponent,
    revealRecipientComponent,
    detailsParticipantsPageComponent,
    matchesPageComponent,
    detailsGroupHubPageComponent,
    myGroupWishlistPageComponent,
  ],
);
