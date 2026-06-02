import 'package:widgetbook/widgetbook.dart';

import 'groups_pages_directory.dart';
import 'groups_widgets_directory.dart';

final groupsDirectory = WidgetbookFolder(
  name: 'Groups',
  children: [groupsPagesDirectory, groupsWidgetsDirectory],
);
