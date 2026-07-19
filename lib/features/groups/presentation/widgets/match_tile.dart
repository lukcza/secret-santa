import 'package:flutter/material.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';

class MatchTile extends StatelessWidget {
  const MatchTile({
    super.key,
    required this.giver,
    required this.recipient,
    this.onTapGiver,
    this.onTapRecipient,
  });

  final UserEntity giver;
  final UserEntity recipient;
  final VoidCallback? onTapGiver;
  final VoidCallback? onTapRecipient;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: cs.onSurface.withValues(alpha: 0.08),
          ),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Giver
            Expanded(
              child: GestureDetector(
                onTap: onTapGiver,
                child: _UserCard(user: giver),
              ),
            ),

            // Arrow
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                Icons.arrow_forward_rounded,
                color: cs.primary,
                size: 22,
              ),
            ),

            // Recipient – avatar wyrównany do lewej, tak samo jak giver
            Expanded(
              child: GestureDetector(
                onTap: onTapRecipient,
                child: _UserCard(user: recipient),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({required this.user});

  final UserEntity user;

  Widget _buildAvatar(BuildContext context, Color bg) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: bg,
      backgroundImage:
          user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
      child: user.photoUrl != null
          ? null
          : Text(
              user.initials,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bg = user.avatarBgColorValue != null
        ? Color(user.avatarBgColorValue!)
        : cs.primary.withValues(alpha: 0.75);

    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildAvatar(context, bg),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.displayName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                if (user.email.isNotEmpty)
                  Text(
                    user.email.split('@').first,
                    style: TextStyle(
                      fontSize: 10,
                      color: cs.onSurface.withValues(alpha: 0.45),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
