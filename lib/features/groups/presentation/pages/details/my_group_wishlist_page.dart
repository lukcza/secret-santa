import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secret_santa/core/extensions/context_extension.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';
import 'package:secret_santa/features/groups/domain/entities/group_entity.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_bloc.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_event.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_state.dart';
import 'package:secret_santa/features/wishlist/domain/entities/wishlist_item_entity.dart';

class MyGroupWishlistPage extends StatefulWidget {
  const MyGroupWishlistPage({
    super.key,
    required this.group,
    required this.currentUser,
  });

  final GroupEntity group;
  final UserEntity currentUser;

  @override
  State<MyGroupWishlistPage> createState() => _MyGroupWishlistPageState();
}

class _MyGroupWishlistPageState extends State<MyGroupWishlistPage> {
  @override
  void initState() {
    super.initState();
    context.read<GroupBloc>().add(
      LoadGroupWishlistEvent(
        uid: widget.currentUser.uid,
        groupId: widget.group.id,
      ),
    );
  }

  void _showAddSheet({WishlistItemEntity? editing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BlocProvider.value(
        value: context.read<GroupBloc>(),
        child: _AddWishItemSheet(
          group: widget.group,
          currentUser: widget.currentUser,
          editing: editing,
        ),
      ),
    );
  }

  void _deleteItem(WishlistItemEntity item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.loc.wishDeleteConfirm),
        content: Text(context.loc.wishDeleteConfirmSub),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(context.loc.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(context.loc.confirmDelete),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      context.read<GroupBloc>().add(
        RemoveWishlistItemEvent(
          uid: widget.currentUser.uid,
          groupId: widget.group.id,
          itemId: item.id,
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.loc.wishRemovedSnack),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          context.loc.myWishlistTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddSheet,
        icon: const Icon(Icons.add_rounded),
        label: Text(context.loc.addWish),
      ),
      body: BlocBuilder<GroupBloc, GroupState>(
        builder: (context, state) {
          if (state.wishlistLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = state.myGroupWishlist;
          if (items.isEmpty) {
            return _buildEmpty(context, cs);
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return _WishlistItemCard(
                item: items[index],
                currency: widget.group.currency,
                onEdit: () => _showAddSheet(editing: items[index]),
                onDelete: () => _deleteItem(items[index]),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmpty(BuildContext context, ColorScheme cs) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🎁', style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 20),
            Text(
              context.loc.myWishlistEmpty,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              context.loc.myWishlistEmptySub,
              style: TextStyle(
                fontSize: 14,
                color: cs.onSurface.withValues(alpha: 0.55),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Wishlist Item Card ────────────────────────────────────────────────────────

class _WishlistItemCard extends StatelessWidget {
  const _WishlistItemCard({
    required this.item,
    required this.currency,
    required this.onEdit,
    required this.onDelete,
  });

  final WishlistItemEntity item;
  final String currency;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: item.isHighPriority
              ? const Color(0xFFFFB300).withValues(alpha: 0.5)
              : cs.onSurface.withValues(alpha: 0.1),
          width: item.isHighPriority ? 1.5 : 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image / placeholder
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 72,
                  height: 72,
                  child: item.imageUrl != null
                      ? Image.network(item.imageUrl!, fit: BoxFit.cover)
                      : Container(
                          color: cs.primary.withValues(alpha: 0.1),
                          child: Icon(
                            Icons.card_giftcard_rounded,
                            size: 32,
                            color: cs.primary.withValues(alpha: 0.5),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (item.isHighPriority)
                      Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          context.loc.highPriority,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (item.price != null)
                          Text(
                            '${item.price!.toStringAsFixed(2)} $currency',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: cs.primary,
                            ),
                          ),
                      ],
                    ),
                    if (item.note != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.note!,
                        style: TextStyle(
                          fontSize: 12,
                          color: cs.onSurface.withValues(alpha: 0.55),
                        ),
                      ),
                    ],
                    if (item.link != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: GestureDetector(
                          onTap: () {
                            // Could open URL launcher
                          },
                          child: Row(
                            children: [
                              Icon(Icons.open_in_new, size: 13, color: cs.primary),
                              const SizedBox(width: 4),
                              Text(
                                context.loc.viewOnline,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: cs.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_rounded, size: 18),
                    onPressed: onEdit,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: context.loc.editWish,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      size: 18,
                      color: cs.error,
                    ),
                    onPressed: onDelete,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: context.loc.wishDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

    );
  }
}

// ── Add / Edit Wish Bottom Sheet ──────────────────────────────────────────────

class _AddWishItemSheet extends StatefulWidget {
  const _AddWishItemSheet({
    required this.group,
    required this.currentUser,
    this.editing,
  });

  final GroupEntity group;
  final UserEntity currentUser;
  final WishlistItemEntity? editing;

  @override
  State<_AddWishItemSheet> createState() => _AddWishItemSheetState();
}

class _AddWishItemSheetState extends State<_AddWishItemSheet> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _linkCtrl;
  late final TextEditingController _noteCtrl;
  late final TextEditingController _imageCtrl;
  bool _highPriority = false;
  bool _saving = false;
  bool _uploadingImage = false;
  String? _titleError;

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (pickedFile == null) return;

    setState(() => _uploadingImage = true);

    try {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${widget.currentUser.uid}.jpg';
      final ref = FirebaseStorage.instance
          .ref()
          .child('wishlist_images')
          .child(fileName);

      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        await ref.putData(
          bytes,
          SettableMetadata(contentType: 'image/jpeg'),
        );
      } else {
        await ref.putFile(File(pickedFile.path));
      }

      final downloadUrl = await ref.getDownloadURL();

      setState(() {
        _imageCtrl.text = downloadUrl;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.loc.imageUploaded),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload failed: $e'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _uploadingImage = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    final e = widget.editing;
    _titleCtrl = TextEditingController(text: e?.title ?? '');
    _priceCtrl = TextEditingController(
      text: e?.price != null ? e!.price!.toStringAsFixed(2) : '',
    );
    _linkCtrl = TextEditingController(text: e?.link ?? '');
    _noteCtrl = TextEditingController(text: e?.note ?? '');
    _imageCtrl = TextEditingController(text: e?.imageUrl ?? '');
    _highPriority = e?.isHighPriority ?? false;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _priceCtrl.dispose();
    _linkCtrl.dispose();
    _noteCtrl.dispose();
    _imageCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (_titleCtrl.text.trim().isEmpty) {
      setState(() {
        _titleError = context.loc.wishTitleRequired;
      });
      return;
    }
    setState(() => _saving = true);
    final item = WishlistItemEntity(
      id: widget.editing?.id ?? '',
      title: _titleCtrl.text.trim(),
      price: double.tryParse(_priceCtrl.text.replaceAll(',', '.')),
      link: _linkCtrl.text.trim().isNotEmpty ? _linkCtrl.text.trim() : null,
      note: _noteCtrl.text.trim().isNotEmpty ? _noteCtrl.text.trim() : null,
      imageUrl: _imageCtrl.text.trim().isNotEmpty ? _imageCtrl.text.trim() : null,
      isHighPriority: _highPriority,
    );
    context.read<GroupBloc>().add(
      AddWishlistItemEvent(
        uid: widget.currentUser.uid,
        groupId: widget.group.id,
        item: item,
      ),
    );
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.loc.wishAddedSnack),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.onSurface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.editing != null
                  ? context.loc.editWish
                  : context.loc.addWish,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            _buildField(
              context,
              controller: _titleCtrl,
              label: context.loc.wishTitleLabel,
              hint: context.loc.wishTitleHint,
              required: true,
              errorText: _titleError,
              onChanged: (val) {
                if (_titleError != null && val.trim().isNotEmpty) {
                  setState(() => _titleError = null);
                }
              },
            ),
            const SizedBox(height: 14),
            _buildField(
              context,
              controller: _priceCtrl,
              label: context.loc.wishPriceLabel,
              hint: context.loc.wishPriceHint,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
              ],
            ),
            const SizedBox(height: 14),
            _buildField(
              context,
              controller: _linkCtrl,
              label: context.loc.wishLinkLabel,
              hint: context.loc.wishLinkHint,
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 14),
            _buildField(
              context,
              controller: _noteCtrl,
              label: context.loc.wishNoteLabel,
              hint: context.loc.wishNoteHint,
              maxLines: 2,
            ),
            const SizedBox(height: 14),
            _buildField(
              context,
              controller: _imageCtrl,
              label: context.loc.wishImageLabel,
              hint: context.loc.wishImageHint,
              keyboardType: TextInputType.url,
              suffixIcon: _uploadingImage
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : IconButton(
                      icon: const Icon(Icons.photo_library_rounded),
                      tooltip: context.loc.pickFromGallery,
                      onPressed: _pickAndUploadImage,
                    ),
            ),
            const SizedBox(height: 16),

            // High Priority switch
            Container(
              decoration: BoxDecoration(
                color: cs.onSurface.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(14),
              ),
              child: SwitchListTile(
                value: _highPriority,
                onChanged: (v) => setState(() => _highPriority = v),
                title: Text(
                  context.loc.wishHighPriority,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                secondary: Icon(
                  Icons.star_rounded,
                  color: _highPriority ? const Color(0xFFFFB300) : cs.onSurface.withValues(alpha: 0.3),
                ),
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _saving ? null : _save,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  context.loc.wishSave,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required String hint,
    bool required = false,
    String? errorText,
    ValueChanged<String>? onChanged,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
    Widget? suffixIcon,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            if (required)
              Text(
                ' *',
                style: TextStyle(
                  color: cs.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            filled: true,
            fillColor: cs.onSurface.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: cs.error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: cs.error, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
