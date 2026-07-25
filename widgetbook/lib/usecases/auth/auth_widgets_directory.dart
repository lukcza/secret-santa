import 'package:widgetbook/widgetbook.dart';

import 'auth_button_usecase.dart';
import 'auth_field_usecase.dart';
import 'auth_form_field_usecase.dart';
import 'login_divider_usecase.dart';
import 'login_form_usecase.dart';
import 'login_header_card_usecase.dart';
import 'profile_avatar_picker_usecase.dart';
import 'register_form_usecase.dart';

final authWidgetsDirectory = WidgetbookFolder(
  name: 'Widgets',
  children: [
    authButtonComponent,
    authFieldComponent,
    authFormFieldComponent,
    loginDividerComponent,
    loginFormComponent,
    loginHeaderCardComponent,
    profileAvatarPickerComponent,
    registerFormComponent,
  ],
);
