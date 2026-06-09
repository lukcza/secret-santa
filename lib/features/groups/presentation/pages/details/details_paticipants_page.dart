import 'package:flutter/material.dart';
import 'package:secret_santa/core/extensions/context_extension.dart';
import 'package:secret_santa/core/theme/app_theme.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';
import 'package:secret_santa/features/groups/domain/entities/group_entity.dart';

class DetailsParticipantsPage extends StatefulWidget {
  const DetailsParticipantsPage({
    super.key,
    required this.users,
    required this.participant,
    required this.group,
    this.onSave,
    this.onRemove,
  });
  final UserEntity participant;
  final List<UserEntity> users;
  final GroupEntity group;
  final void Function(List<String> excludedUIDs)? onSave;
  final VoidCallback? onRemove;

  @override
  State<DetailsParticipantsPage> createState() =>
      _DetailsParticipantsPageState();
}

class _DetailsParticipantsPageState extends State<DetailsParticipantsPage>
    with SingleTickerProviderStateMixin {
  late final Set<String> _excludedUIDs;
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _excludedUIDs = Set<String>.from(
      widget.group.excludedPairs[widget.participant.uid] ?? const [],
    );
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  List<UserEntity> get _otherParticipants =>
      widget.users.where((u) => u.uid != widget.participant.uid).toList();

  List<String> get _otherParticipantsUIDs =>
      widget.group.participantsUIDs
          .where((u) => u != widget.participant.uid)
          .toList();

  void _toggleExclusion(String uid) {
    setState(() {
      if (_excludedUIDs.contains(uid)) {
        _excludedUIDs.remove(uid);
      } else {
        _excludedUIDs.add(uid);
      }
      _hasChanges = true;
    });
  }

  Future<void> _confirmRemove() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => _RemoveConfirmDialog(
            participantName: widget.participant.displayName,
          ),
    );
    if (confirmed == true && mounted) {
      widget.onRemove?.call();
      Navigator.of(context).pop();
    }
  }

  void _save() {
    widget.onSave?.call(_excludedUIDs.toList());
    setState(() => _hasChanges = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.loc.changesSaved),
        backgroundColor: AppTheme.forest,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isAdmin = widget.group.authorUID == widget.participant.uid;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(context.loc.manageParticipantAppBarTitle),
        actions: [
          if (_hasChanges)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton(
                onPressed: _save,
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.gold,
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                child: Text(context.loc.manageParticipantSaveChanges),
              ),
            ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _ParticipantHeader(
                participant: widget.participant,
                isAdmin: isAdmin,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: _SectionHeader(
                  icon: Icons.block_rounded,
                  iconColor: AppTheme.primary,
                  title: context.loc.exludionSectionTitle,
                  subtitle: context.loc.addExlusionSubtitle,
                ),
              ),
            ),

            _otherParticipants.isEmpty
                ? SliverToBoxAdapter(child: _EmptyExclusionsHint())
                : SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final user = _otherParticipants[index];
                      final excluded = _excludedUIDs.contains(user.uid);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _ExclusionTile(
                          user: user,
                          excluded: excluded,
                          onToggle: () => _toggleExclusion(user.uid),
                        ),
                      );
                    }, childCount: _otherParticipants.length),
                  ),
                ),
            if (_excludedUIDs.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: _ExclusionsSummary(
                    excludedCount: _excludedUIDs.length,
                    totalCount: _otherParticipants.length,
                  ),
                ),
              ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 32, 16, 8),
                child: _SectionHeader(
                  icon: Icons.warning_amber_rounded,
                  iconColor: AppTheme.primaryLight,
                  title: context.loc.dangerZone,
                  subtitle: context.loc.dangerZoneSubtitle,
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                child: _RemoveButton(
                  participantName: widget.participant.displayName,
                  isAdmin: isAdmin,
                  onRemove: isAdmin ? null : _confirmRemove,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          _hasChanges
              ? FloatingActionButton.extended(
                onPressed: _save,
                backgroundColor: AppTheme.forest,
                foregroundColor: Colors.white,
                icon: const Icon(Icons.check_rounded),
                label: Text(
                  context.loc.save,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
              : null,
    );
  }
}

class _ParticipantHeader extends StatelessWidget {
  const _ParticipantHeader({required this.participant, required this.isAdmin});

  final UserEntity participant;
  final bool isAdmin;

  Color get _avatarBg =>
      participant.avatarBgColorValue != null
          ? Color(participant.avatarBgColorValue!)
          : AppTheme.primaryLight;

  Color get _avatarFg =>
      participant.avatarForegroundColorValue != null
          ? Color(participant.avatarForegroundColorValue!)
          : Colors.white;

  IconData get _avatarIcon =>
      participant.avatarIconCodePoint != null
          ? IconData(
            participant.avatarIconCodePoint!,
            fontFamily: 'MaterialIcons',
          )
          : Icons.person_rounded;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.onSurface.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Hero(
            tag: 'participant_avatar_${participant.uid}',
            child:
                participant.photoUrl != null
                    ? CircleAvatar(
                      radius: 34,
                      backgroundImage: NetworkImage(participant.photoUrl!),
                    )
                    : CircleAvatar(
                      radius: 34,
                      backgroundColor: _avatarBg,
                      child:
                          participant.avatarIconCodePoint != null
                              ? Icon(_avatarIcon, color: _avatarFg, size: 28)
                              : Text(
                                participant.initials,
                                style: TextStyle(
                                  color: _avatarFg,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                    ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        participant.displayName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isAdmin) ...[
                      const SizedBox(width: 8),
                      _Badge(
                        label: context.loc.manageParticipantAdminBadge,
                        color: AppTheme.gold,
                        icon: Icons.star_rounded,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  participant.email,
                  style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.5),
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color, required this.icon});

  final String label;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 18),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.55),
          ),
        ),
        const SizedBox(height: 4),
        Divider(
          thickness: 1,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
        ),
      ],
    );
  }
}

class _ExclusionTile extends StatelessWidget {
  const _ExclusionTile({
    required this.user,
    required this.excluded,
    required this.onToggle,
  });

  final UserEntity user;
  final bool excluded;
  final VoidCallback onToggle;

  Color get _avatarBg =>
      user.avatarBgColorValue != null
          ? Color(user.avatarBgColorValue!)
          : AppTheme.slateBlue;

  Color get _avatarFg =>
      user.avatarForegroundColorValue != null
          ? Color(user.avatarForegroundColorValue!)
          : Colors.white;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color:
            excluded ? AppTheme.primary.withOpacity(0.07) : colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              excluded
                  ? AppTheme.primary.withOpacity(0.4)
                  : colorScheme.onSurface.withOpacity(0.08),
          width: excluded ? 1.5 : 1.0,
        ),
      ),
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              user.photoUrl != null
                  ? CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(user.photoUrl!),
                  )
                  : CircleAvatar(
                    radius: 20,
                    backgroundColor: _avatarBg,
                    child:
                        user.avatarIconCodePoint != null
                            ? Icon(
                              IconData(
                                user.avatarIconCodePoint!,
                                fontFamily: 'MaterialIcons',
                              ),
                              color: _avatarFg,
                              size: 18,
                            )
                            : Text(
                              user.initials,
                              style: TextStyle(
                                color: _avatarFg,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                  ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color:
                            excluded ? AppTheme.primary : colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      user.email,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child:
                    excluded
                        ? _ExclusionChip(
                          key: const ValueKey('excluded'),
                          label: context.loc.exclude,
                          icon: Icons.block_rounded,
                          color: AppTheme.primary,
                          filled: true,
                        )
                        : _ExclusionChip(
                          key: const ValueKey('include'),
                          label: context.loc.allow,
                          icon: Icons.check_circle_outline_rounded,
                          color: AppTheme.forest,
                          filled: false,
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExclusionChip extends StatelessWidget {
  const _ExclusionChip({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.filled,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: filled ? color : color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: filled ? null : Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: filled ? Colors.white : color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: filled ? Colors.white : color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExclusionsSummary extends StatelessWidget {
  const _ExclusionsSummary({
    required this.excludedCount,
    required this.totalCount,
  });

  final int excludedCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: AppTheme.primary, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                children: [
                  TextSpan(
                    text: '$excludedCount z $totalCount ',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                  ),
                  TextSpan(text: context.loc.excludedSummary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyExclusionsHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.people_outline_rounded,
              size: 48,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.25),
            ),
            const SizedBox(height: 8),
            Text(
              context.loc.noMoreParticipants,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RemoveButton extends StatelessWidget {
  const _RemoveButton({
    required this.participantName,
    required this.isAdmin,
    required this.onRemove,
  });

  final String participantName;
  final bool isAdmin;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed: onRemove,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.primaryLight,
            side: BorderSide(
              color:
                  isAdmin
                      ? AppTheme.primaryLight.withOpacity(0.25)
                      : AppTheme.primaryLight.withOpacity(0.6),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            disabledForegroundColor: AppTheme.primaryLight.withOpacity(0.35),
          ),
          icon: const Icon(Icons.person_remove_rounded),
          label: Text(
            '${context.loc.remove} $participantName ${context.loc.fromGroup}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
        if (isAdmin)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              context.loc.cantRemoveAdmin,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
          ),
      ],
    );
  }
}

class _RemoveConfirmDialog extends StatelessWidget {
  const _RemoveConfirmDialog({required this.participantName});

  final String participantName;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: colorScheme.surface,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_remove_rounded,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(child: Text(context.loc.removePatricipant)),
        ],
      ),
      content: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 14,
            color: colorScheme.onSurface,
            height: 1.5,
          ),
          children: [
            TextSpan(text: context.loc.sureDelete),
            TextSpan(
              text: participantName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: context.loc.sureDeleteSubtitle),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          style: TextButton.styleFrom(
            foregroundColor: colorScheme.onSurface.withOpacity(0.6),
          ),
          child: Text(context.loc.cancel),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            context.loc.delete,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
