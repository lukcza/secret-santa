import 'package:widgetbook/widgetbook.dart';

import 'auth_pages_directory.dart';
import 'auth_widgets_directory.dart';

final authDirectory = WidgetbookFolder(
  name: 'Auth',
  children: [
    authPagesDirectory,
    authWidgetsDirectory,
  ],
);
