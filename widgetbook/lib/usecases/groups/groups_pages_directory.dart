import 'package:widgetbook/widgetbook.dart';

import 'create_group_page_component.dart';
import 'manually_invite_page_usecase.dart';
import 'set_date_group_page_usecase.dart';
import 'confirm_group_page_usecase.dart';

final groupsPagesDirectory = WidgetbookFolder(
  name: 'Pages',
  children: [
    createGroupPageComponent,
    manuallyInvitePageComponent,
    setDateGroupPageComponent,
    confirmGroupPageComponent,
  ],
);
