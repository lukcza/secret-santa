import 'package:flutter/material.dart';
import 'package:secret_santa/features/auth/presentation/widgets/avatar_color_picker.dart';
import 'package:secret_santa/features/auth/presentation/widgets/profile_avatar_picker.dart';
import 'package:widgetbook/widgetbook.dart';

final profileAvatarPickerComponent = WidgetbookComponent(
  name: 'ProfileAvatarPicker',
  useCases: [
    WidgetbookUseCase(
      name: '① Initials Default State',
      builder: (context) {
        final name = context.knobs.string(
          label: 'Nickname',
          initialValue: 'Santa Claus',
        );
        return Scaffold(
          body: Center(
            child: ProfileAvatarPicker(
              imageBytes: null,
              nickname: name,
              backgroundColor: AvatarColorPicker.presetColors[0],
              onImageSelected: (_) {},
            ),
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: '② Custom Background Color',
      builder: (context) {
        final name = context.knobs.string(
          label: 'Nickname',
          initialValue: 'Elf Rudolph',
        );
        return Scaffold(
          body: Center(
            child: ProfileAvatarPicker(
              imageBytes: null,
              nickname: name,
              backgroundColor: AvatarColorPicker.presetColors[2],
              onImageSelected: (_) {},
            ),
          ),
        );
      },
    ),
  ],
);
