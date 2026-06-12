import 'package:flutter/material.dart';
import 'package:secret_santa/core/extensions/context_extension.dart';
import 'package:secret_santa/core/l10n/app_localizations.dart';
import 'package:secret_santa/core/enums/user_status.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';
import 'package:secret_santa/features/groups/domain/entities/group_entity.dart';
import 'package:secret_santa/features/groups/presentation/pages/details/details_paticipants_page.dart';

class ParticipantTile extends StatelessWidget {
  const ParticipantTile({
    super.key,
    required this.uid,
    required this.status,
    required this.isAuthor,
    required this.group,
    required this.animation,
    required this.isExpanded,
    required this.onTap,
    required this.users,
    required this.participant,
  });

  final String uid;
  final UserStatus status;
  final bool isAuthor;
  final GroupEntity group;
  final Animation<double> animation;
  final bool isExpanded;
  final VoidCallback onTap;
  final List<UserEntity> users;
  final UserEntity participant;

  String _statusLabel(UserStatus status, AppLocalizations loc) {
    switch (status) {
      case UserStatus.creator:
        return loc.host.toUpperCase();
      case UserStatus.confirmed:
        return loc.confirmed.toUpperCase();
      case UserStatus.invited:
        return loc.invited.toUpperCase();
      case UserStatus.pending:
        return loc.pending.toUpperCase();
      case UserStatus.declined:
        return loc.declined.toUpperCase();
    }
  }

  Color _statusColor(BuildContext context, UserStatus status) {
    switch (status) {
      case UserStatus.creator:
        return Theme.of(context).colorScheme.tertiary;
      case UserStatus.confirmed:
        return const Color(0xFF2E7D32);
      case UserStatus.invited:
        return const Color(0xFF1565C0);
      case UserStatus.pending:
        return const Color(0xFFE65100);
      case UserStatus.declined:
        return Theme.of(context).colorScheme.primary;
    }
  }

  Widget _buildExpandedParticpantSettings(BuildContext context) {
    final statusColor = _statusColor(context, status);
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.10),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          final double opacity =
              isExpanded
                  ? ((animation.value - 0.08) / 0.92).clamp(0.0, 1.0)
                  : 0.0;
          return Opacity(opacity: opacity, child: child);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _ActionButton(
              icon: Icons.manage_accounts_rounded,
              label: context.loc.manage,
              color: statusColor,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (context) => DetailsParticipantsPage(
                          group: group,
                          users: users,
                          participant: participant,
                        ),
                  ),
                );
              },
            ),
            Container(
              width: 1,
              height: 24,
              color: statusColor.withValues(alpha: 0.2),
            ),
            _ActionButton(
              icon: Icons.person_outline_rounded,
              label: context.loc.profile,
              color: statusColor,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusLabel = _statusLabel(status, context.loc);
    final statusColor = _statusColor(context, status);

    final avatarBg =
        participant.avatarBgColorValue != null
            ? Color(participant.avatarBgColorValue!)
            : statusColor.withValues(alpha: 0.75);
    final avatarFg =
        participant.avatarForegroundColorValue != null
            ? Color(participant.avatarForegroundColorValue!)
            : Colors.white;
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              border: Border.all(
                color:
                    isExpanded
                        ? statusColor.withValues(alpha: 0.45)
                        : Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.08),
                width: isExpanded ? 1.5 : 1.0,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: avatarBg,
                  backgroundImage:
                      participant.photoUrl != null
                          ? NetworkImage(participant.photoUrl!)
                          : null,
                  child:
                      participant.photoUrl != null
                          ? null
                          : Text(
                            participant.initials,
                            style: TextStyle(
                              color: avatarFg,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        participant.nickname ?? participant.email!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              statusLabel,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color:
                        isExpanded
                            ? statusColor
                            : Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.35),
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
        ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Align(
                alignment: Alignment.topCenter,
                widthFactor: isExpanded ? 2 : 1,
                heightFactor: isExpanded ? animation.value : 0.08,
                child: child,
              );
            },
            child: _buildExpandedParticpantSettings(context),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
