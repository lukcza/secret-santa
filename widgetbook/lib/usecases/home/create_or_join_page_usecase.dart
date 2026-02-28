import 'package:secret_santa/features/home/presentation/pages/create_or_join_page.dart';
import 'package:widgetbook/widgetbook.dart';

final createOrJoinPageComponent = WidgetbookComponent(
  name: 'CreateOrJoinPage',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => CreateOrJoinPage(),
    ),
  ],
);