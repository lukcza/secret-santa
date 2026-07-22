import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:secret_santa/core/extensions/context_extension.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';
import 'package:secret_santa/features/groups/domain/entities/group_entity.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_bloc.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_event.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_state.dart';
import 'package:secret_santa/features/groups/presentation/pages/details/details_group_admin.dart'
    show buildGroupInfoCard;
import 'package:secret_santa/features/groups/presentation/pages/details/my_group_wishlist_page.dart';
import 'package:secret_santa/features/groups/presentation/pages/details/reveal_recipient_page.dart';
import 'package:secret_santa/features/groups/presentation/pages/details/details_group_user.dart';

class DetailsGroupHubPage extends StatefulWidget {
  const DetailsGroupHubPage({
    super.key,
    required this.group,
    required this.currentUid,
    required this.currentUser,
  });

  final GroupEntity group;
  final String currentUid;
  final UserEntity currentUser;

  @override
  State<DetailsGroupHubPage> createState() => _DetailsGroupHubPageState();
}

class _DetailsGroupHubPageState extends State<DetailsGroupHubPage> {
  List<UserEntity> participants = [];

  @override
  void initState() {
    super.initState();
    context.read<GroupBloc>().add(
      GetGroupParticipantsEvent(groupId: widget.group.id),
    );
  }

  UserEntity? _findUser(String uid) {
    try {
      return participants.firstWhere((u) => u.uid == uid || u.email == uid);
    } catch (_) {
      return null;
    }
  }

  void _openMyWishlist() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: context.read<GroupBloc>(),
          child: MyGroupWishlistPage(
            group: widget.group,
            currentUser: widget.currentUser,
          ),
        ),
      ),
    );
  }

  void _openRecipientView(BuildContext context, GroupEntity group) {
    final recipientUid = group.matches[widget.currentUid];
    if (recipientUid == null) return;

    final recipient = _findUser(recipientUid);
    if (recipient == null) return;

    // RevealRecipientPage — "tylko raz" logic is inside that page
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RevealRecipientPageWithWishlist(
          recipient: recipient,
          group: group,
          currentUid: widget.currentUid,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupBloc, GroupState>(
      listener: (context, state) {
        if (state.participants.isNotEmpty) {
          setState(() => participants = state.participants);
        }
      },
      builder: (context, state) {
        final group = state.group ?? widget.group;
        final hasMatches = group.matches.isNotEmpty;
        final cs = Theme.of(context).colorScheme;

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            context.go('/');
          },
          child: Scaffold(
            backgroundColor: cs.surface,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
              title: Text(
                group.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: false,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go('/'),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    // Info cards (budget + date)
                    Row(
                      children: [
                        Expanded(
                          child: buildGroupInfoCard(
                            context,
                            context.loc.budget,
                            '${group.budgetLimit} ${group.currency}',
                            true,
                          ),
                        ),
                        SizedBox(width: MediaQuery.sizeOf(context).width * 0.1),
                        Expanded(
                          child: buildGroupInfoCard(
                            context,
                            context.loc.exchangeDate,
                            '${group.eventDate.day}.${group.eventDate.month}.${group.eventDate.year}',
                            false,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    // Action cards
                    _ActionCard(
                      icon: Icons.card_giftcard_rounded,
                      label: context.loc.groupHubMyWishlistBtn,
                      subtitle: context.loc.myWishlistSubtitle,
                      color: cs.primary,
                      onTap: _openMyWishlist,
                    ),
                    const SizedBox(height: 14),
                    _ActionCard(
                      icon: hasMatches
                          ? Icons.person_search_rounded
                          : Icons.lock_rounded,
                      label: context.loc.groupHubMyLotBtn,
                      subtitle: hasMatches
                          ? context.loc.seeRecipientWishlist
                          : context.loc.groupHubDrawNotReadySub,
                      color: hasMatches ? const Color(0xFFE53935) : cs.onSurface.withValues(alpha: 0.4),
                      onTap: hasMatches
                          ? () => _openRecipientView(context, group)
                          : null,
                    ),
                    const SizedBox(height: 28),
                    // Participants list
                    _buildParticipantsList(context, group),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildParticipantsList(BuildContext context, GroupEntity group) {
    final cs = Theme.of(context).colorScheme;
    final entries = group.participants.entries.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              context.loc.allParticipants,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: cs.onSurface.withValues(alpha: 0.2)),
              ),
              child: Text(
                '${entries.length} ${context.loc.elevs}',
                style: TextStyle(
                  color: cs.tertiary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...entries.map((entry) {
          final uid = entry.key;
          final user = _findUser(uid);
          final isMe = uid == widget.currentUid;
          final displayName = user?.displayName ?? uid;
          final avatarBg = user?.avatarBgColorValue != null
              ? Color(user!.avatarBgColorValue!)
              : cs.primary.withValues(alpha: 0.65);
          final avatarFg = user?.avatarForegroundColorValue != null
              ? Color(user!.avatarForegroundColorValue!)
              : Colors.white;

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isMe
                  ? cs.primary.withValues(alpha: 0.07)
                  : cs.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isMe
                    ? cs.primary.withValues(alpha: 0.3)
                    : cs.onSurface.withValues(alpha: 0.08),
                width: isMe ? 1.5 : 1.0,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: avatarBg,
                  backgroundImage: user?.photoUrl != null
                      ? NetworkImage(user!.photoUrl!)
                      : null,
                  child: user?.photoUrl == null
                      ? Text(
                          user?.initials ?? '?',
                          style: TextStyle(
                            color: avatarFg,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isMe
                        ? '$displayName ${context.loc.meSuffix}'
                        : displayName,
                    style: TextStyle(
                      fontWeight: isMe ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

// ── Action Card ──────────────────────────────────────────────────────────────

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDisabled = onTap == null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        opacity: isDisabled ? 0.5 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: color.withValues(alpha: isDisabled ? 0.15 : 0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: cs.onSurface.withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isDisabled)
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: cs.onSurface.withValues(alpha: 0.4),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── RevealRecipientPage wrapper (handles "only once" + navigate to wishlist) ─

class RevealRecipientPageWithWishlist extends StatelessWidget {
  const RevealRecipientPageWithWishlist({
    super.key,
    required this.recipient,
    required this.group,
    required this.currentUid,
  });

  final UserEntity recipient;
  final GroupEntity group;
  final String currentUid;

  @override
  Widget build(BuildContext context) {
    return RevealRecipientPage(
      recipient: recipient,
      groupId: group.id,
      onViewWishlist: () {
        // Replace the reveal with the recipient wishlist view
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<GroupBloc>(),
              child: DetailsGroupUser(
                group: group,
                currentUid: currentUid,
              ),
            ),
          ),
        );
      },
    );
  }
}
