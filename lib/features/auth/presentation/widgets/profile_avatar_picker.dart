import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secret_santa/core/extensions/context_extension.dart';
import 'package:secret_santa/features/auth/presentation/widgets/image_cropper_dialog.dart';

class ProfileAvatarPicker extends StatelessWidget {
  final Uint8List? imageBytes;
  final String nickname;
  final Color backgroundColor;
  final ValueChanged<Uint8List?> onImageSelected;
  final double size;

  const ProfileAvatarPicker({
    super.key,
    required this.imageBytes,
    required this.nickname,
    required this.backgroundColor,
    required this.onImageSelected,
    this.size = 130.0,
  });

  String _getInitials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'SS';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length > 1) {
      final first = parts[0].isNotEmpty ? parts[0][0] : '';
      final second = parts[1].isNotEmpty ? parts[1][0] : '';
      return (first + second).toUpperCase();
    }
    return trimmed.substring(0, trimmed.length >= 2 ? 2 : trimmed.length).toUpperCase();
  }

  Future<void> _showPickerBottomSheet(BuildContext context) async {
    final picker = ImagePicker();

    await showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  context.loc.chooseImageSourceTitle,
                  style: Theme.of(bottomSheetContext)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Text('🖼️', style: TextStyle(fontSize: 26)),
                  title: Text(context.loc.chooseFromGallery),
                  onTap: () async {
                    Navigator.of(bottomSheetContext).pop();
                    final XFile? file = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 90,
                    );
                    if (file != null) {
                      final bytes = await file.readAsBytes();
                      if (context.mounted) {
                        final cropped = await ImageCropperDialog.show(context, bytes);
                        if (cropped != null) {
                          onImageSelected(cropped);
                        }
                      }
                    }
                  },
                ),
                ListTile(
                  leading: const Text('📷', style: TextStyle(fontSize: 26)),
                  title: Text(context.loc.takePhoto),
                  onTap: () async {
                    Navigator.of(bottomSheetContext).pop();
                    final XFile? file = await picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 90,
                    );
                    if (file != null) {
                      final bytes = await file.readAsBytes();
                      if (context.mounted) {
                        final cropped = await ImageCropperDialog.show(context, bytes);
                        if (cropped != null) {
                          onImageSelected(cropped);
                        }
                      }
                    }
                  },
                ),
                if (imageBytes != null)
                  ListTile(
                    leading: const Text('🗑️', style: TextStyle(fontSize: 26)),
                    title: Text(
                      context.loc.removePhoto,
                      style: const TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      Navigator.of(bottomSheetContext).pop();
                      onImageSelected(null);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(nickname);

    return GestureDetector(
      onTap: () => _showPickerBottomSheet(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: backgroundColor.withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
              border: Border.all(
                color: Colors.white,
                width: 4,
              ),
            ),
            child: ClipOval(
              child: imageBytes != null
                  ? Image.memory(
                      imageBytes!,
                      width: size,
                      height: size,
                      fit: BoxFit.cover,
                    )
                  : Center(
                      child: Text(
                        initials,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size * 0.36,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: size * 0.3,
              height: size * 0.3,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.5),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                imageBytes != null ? Icons.edit : Icons.add,
                color: Colors.white,
                size: size * 0.18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
