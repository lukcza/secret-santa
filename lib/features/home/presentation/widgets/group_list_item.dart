import 'package:flutter/material.dart';
import 'package:secret_santa/core/enums/group_status.dart';
import 'package:secret_santa/core/extensions/context_extension.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';
import 'package:secret_santa/features/groups/domain/entities/group_entity.dart';

class GroupListItem extends StatelessWidget {
  const GroupListItem({
    super.key,
    required this.group,
    required this.user,
    this.onTap,
  });

  final GroupEntity group;
  final UserEntity user;
  final VoidCallback? onTap;

  bool get _isAuthor => user.uid == group.authorUID;

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(context);
    final statusIcon = _getStatusIcon();
    final statusText = _getStatusText(context);
    final showRedLeftBorder = group.state == GroupStatus.recruiting && !_isAuthor;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF112217),
        borderRadius: BorderRadius.circular(24),
        border: showRedLeftBorder
            ? const Border(
                left: BorderSide(color: Color(0xFFD32F2F), width: 5),
              )
            : Border.all(color: Colors.white.withOpacity(0.05), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left Column: Details & Action Button
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Status Line
                      Row(
                        children: [
                          Icon(
                            statusIcon,
                            size: 16,
                            color: statusColor,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              statusText.toUpperCase(),
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Group Title
                      Text(
                        group.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),

                      // Participant count
                      Row(
                        children: [
                          const Icon(
                            Icons.people_outline_rounded,
                            size: 16,
                            color: Color(0xFFA1B0A6),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${group.participantsUIDs.length} ${context.loc.participantsJoined}',
                            style: const TextStyle(
                              color: Color(0xFFA1B0A6),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Action Button (Pill shape)
                      _buildActionButton(context),
                    ],
                  ),
                ),

                const SizedBox(width: 14),

                // Right Column: Thumbnail Image with Badge
                _buildThumbnailContainer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    final isDrawn = group.state == GroupStatus.drawn || group.state == GroupStatus.active;
    final isInviteButton = group.state == GroupStatus.recruiting && !_isAuthor;

    final String buttonText;
    final IconData buttonIcon;
    final Color buttonBgColor;
    final Color buttonTextColor;

    if (isDrawn) {
      buttonText = context.loc.viewMatch;
      buttonIcon = Icons.visibility_outlined;
      buttonBgColor = const Color(0xFF1D3B29);
      buttonTextColor = Colors.white;
    } else if (_isAuthor) {
      buttonText = context.loc.editGroup;
      buttonIcon = Icons.settings_outlined;
      buttonBgColor = const Color(0xFF1D3B29);
      buttonTextColor = Colors.white;
    } else if (isInviteButton) {
      buttonText = 'Invite';
      buttonIcon = Icons.person_add_alt_1_outlined;
      buttonBgColor = const Color(0xFFD32F2F);
      buttonTextColor = Colors.white;
    } else {
      buttonText = context.loc.viewMatch;
      buttonIcon = Icons.arrow_forward_rounded;
      buttonBgColor = const Color(0xFF1D3B29);
      buttonTextColor = Colors.white;
    }

    return Container(
      decoration: BoxDecoration(
        color: buttonBgColor,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            buttonIcon,
            size: 16,
            color: buttonTextColor,
          ),
          const SizedBox(width: 8),
          Text(
            buttonText,
            style: TextStyle(
              color: buttonTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnailContainer() {
    // Choose icon / styling based on group state
    IconData centerIcon;
    List<Color> gradientColors;
    IconData badgeIcon;

    switch (group.state) {
      case GroupStatus.drawn:
      case GroupStatus.active:
        centerIcon = Icons.forest_rounded; // Christmas Tree
        gradientColors = [const Color(0xFF1E3A28), const Color(0xFF0F1E15)];
        badgeIcon = Icons.visibility_rounded;
        break;
      case GroupStatus.draft:
      case GroupStatus.recruiting:
        centerIcon = Icons.fireplace_rounded; // Fireplace
        gradientColors = [const Color(0xFF2C1E14), const Color(0xFF140D08)];
        badgeIcon = Icons.star_rounded;
        break;
      case GroupStatus.finished:
      default:
        centerIcon = Icons.card_giftcard_rounded; // Gifts
        gradientColors = [const Color(0xFF1E283A), const Color(0xFF0D141E)];
        badgeIcon = Icons.check_circle_rounded;
        break;
    }

    return Stack(
      children: [
        Container(
          width: 95,
          height: 95,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Center(
            child: Icon(
              centerIcon,
              size: 48,
              color: Colors.white.withOpacity(0.85),
            ),
          ),
        ),
        Positioned(
          top: 6,
          right: 6,
          child: Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Icon(
              badgeIcon,
              size: 14,
              color: const Color(0xFFFFC107),
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(BuildContext context) {
    switch (group.state) {
      case GroupStatus.drawn:
      case GroupStatus.active:
        return const Color(0xFF4CAF50); // Bright Green
      case GroupStatus.draft:
        return const Color(0xFFFFC107); // Gold Yellow
      case GroupStatus.recruiting:
        return _isAuthor ? const Color(0xFFFFC107) : const Color(0xFFEF5350); // Red if drawing soon
      case GroupStatus.finished:
        return const Color(0xFF90A4AE); // Muted Slate
      default:
        return Colors.white70;
    }
  }

  IconData _getStatusIcon() {
    switch (group.state) {
      case GroupStatus.drawn:
      case GroupStatus.active:
        return Icons.check_circle_rounded;
      case GroupStatus.draft:
        return Icons.emoji_events_rounded;
      case GroupStatus.recruiting:
        return _isAuthor ? Icons.hourglass_top_rounded : Icons.alarm_rounded;
      case GroupStatus.finished:
        return Icons.done_all_rounded;
      default:
        return Icons.info_outline;
    }
  }

  String _getStatusText(BuildContext context) {
    switch (group.state) {
      case GroupStatus.drawn:
        return context.loc.drawingComplete;
      case GroupStatus.active:
        return context.loc.elvesAreHelpingSanta;
      case GroupStatus.draft:
        return 'WAITING FOR ORGANIZER';
      case GroupStatus.recruiting:
        return _isAuthor ? 'WAITING FOR ORGANIZER' : 'DRAWING IN 2 DAYS';
      case GroupStatus.finished:
        return context.loc.evryoneGotAPresents;
      default:
        return 'ACTIVE';
    }
  }
}
