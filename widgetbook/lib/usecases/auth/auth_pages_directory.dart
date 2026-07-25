import 'package:widgetbook/widgetbook.dart';

import 'login_page_usecase.dart';
import 'register_page_usecase.dart';
import 'splash_page_usecase.dart';

final authPagesDirectory = WidgetbookFolder(
  name: 'Pages',
  children: [
    loginPageComponent,
    registerPageComponent,
    splashPageComponent,
  ],
);
