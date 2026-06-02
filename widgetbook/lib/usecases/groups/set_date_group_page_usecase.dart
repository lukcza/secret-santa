import 'package:secret_santa/features/groups/presentation/pages/set_date_group_page.dart';
import 'package:widgetbook/widgetbook.dart';

final setDateGroupPageComponent = WidgetbookComponent(
  name: 'SetDateGroupPage',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => SetDateGroupPage(),
    ),
  ],
);
