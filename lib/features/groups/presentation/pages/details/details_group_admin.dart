import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_santa/core/extensions/context_extension.dart';
import 'package:secret_santa/core/theme/app_theme.dart';
import 'package:secret_santa/core/enums/user_status.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';
import 'package:secret_santa/features/groups/domain/entities/group_entity.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_bloc.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_event.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_state.dart';
import 'package:secret_santa/features/groups/presentation/pages/create/manually_invite_page.dart';
import 'package:secret_santa/features/groups/presentation/widgets/invite_card.dart';
import 'package:secret_santa/features/groups/presentation/widgets/match_tile.dart';
import 'package:secret_santa/features/groups/presentation/widgets/participants_list.dart';
import 'package:go_router/go_router.dart';

/// Widok strony grupy dla administratora (twórcy grupy).
/// Obsługuje dwa stany:
/// - [group.matches.isEmpty] → tryb rekrutacji: InviteCard, lista uczestników, "Start Drawing"
/// - [group.matches.isNotEmpty] → tryb po losowaniu: lista wylosowanych par (read-only)
class DetailsGroupAdmin extends StatefulWidget {
  DetailsGroupAdmin({super.key, required this.group});
  GroupEntity group;

  @override
  State<DetailsGroupAdmin> createState() => _DetailsGroupAdminState();
}

class _DetailsGroupAdminState extends State<DetailsGroupAdmin> {
  List<UserEntity> users = [];

  @override
  void initState() {
    super.initState();
    context.read<GroupBloc>().add(
      GetGroupParticipantsEvent(groupId: widget.group.id),
    );
  }

  void Function(List<String>? emails)? _onBack() {
    return (emails) {
      setState(() {
        final Map<String, UserStatus> map = Map.from(widget.group.participants);
        final List<String> uids = List.from(widget.group.participantsUIDs);
        for (String email in emails!) {
          if (map.containsKey(email)) continue;
          map[email] = UserStatus.invited;
          uids.add(email);
        }
        final updatedGroup = widget.group.copyWith(
          participants: map,
          participantsUIDs: uids,
        );
        widget.group = updatedGroup;
        context.read<GroupBloc>().add(UpdateGroupEvent(updatedGroup));
      });
    };
  }

  void _showAddMoreSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder:
          (_) => BlocProvider.value(
            value: context.read<GroupBloc>(),
            child: DraggableScrollableSheet(
              initialChildSize: 0.90,
              minChildSize: 0.50,
              maxChildSize: 0.95,
              expand: false,
              builder:
                  (_, scrollController) => ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    child: ManuallyInvitePage(onBack: _onBack()),
                  ),
            ),
          ),
    );
  }

  UserEntity? _findUser(String uid) {
    try {
      return users.firstWhere((u) => u.uid == uid || u.email == uid);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupBloc, GroupState>(
      listener: (context, state) {
        if (state.participants.isNotEmpty) {
          setState(() => users = state.participants);
        }
      },
      builder: (context, state) {
        final group = state.group ?? widget.group;
        final hasMatches = group.matches.isNotEmpty;

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            context.go('/');
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(group.title),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go('/'),
              ),
            ),
            body: SafeArea(
              child: hasMatches
                  ? _buildDrawnView(context, group)
                  : _buildRecruitingView(context, group),
            ),
          ),
        );
      },
    );
  }

  // ── Widok rekrutacji (przed losowaniem) ─────────────────────────────────

  Widget _buildRecruitingView(BuildContext context, GroupEntity group) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          const SizedBox(height: 12),
          InviteCard(inviteCode: group.inviteCode),
          const SizedBox(height: 12),
          _buildInfoRow(context, group),
          const SizedBox(height: 16),
          _buildParticipantsHeader(context, group),
          const SizedBox(height: 16),
          Expanded(child: ParticipantsList(group: group, users: users)),
          const SizedBox(height: 16),
          _StartDrawingButton(colorScheme: Theme.of(context).colorScheme),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ── Widok po losowaniu (lista par) ───────────────────────────────────────

  Widget _buildDrawnView(BuildContext context, GroupEntity group) {
    final matches = group.matches;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          const SizedBox(height: 12),
          _buildInfoRow(context, group),
          const SizedBox(height: 16),
          // Nagłówek sekcji par
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.shuffle_rounded,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                context.loc.drawnPairsAdminTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  '${matches.length}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          // Nagłówki kolumn
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 2),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    context.loc.giversColumnHeader,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.45),
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                const SizedBox(width: 42),
                Expanded(
                  child: Text(
                    context.loc.receiversColumnHeader,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.45),
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child:
                matches.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                      padding: const EdgeInsets.only(top: 4, bottom: 8),
                      itemCount: matches.length,
                      itemBuilder: (context, index) {
                        final entry = matches.entries.elementAt(index);
                        final giver = _findUser(entry.key);
                        final recipient = _findUser(entry.value);
                        if (giver == null || recipient == null) {
                          return const SizedBox.shrink();
                        }
                        return MatchTile(giver: giver, recipient: recipient);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  // ── Shared helpers ──────────────────────────────────────────────────────

  Widget _buildInfoRow(BuildContext context, GroupEntity group) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            context,
            context.loc.budget,
            '${group.budgetLimit} ${group.currency}',
            true,
          ),
        ),
        SizedBox(width: MediaQuery.sizeOf(context).width * 0.10),
        Expanded(
          child: _buildInfoCard(
            context,
            context.loc.exchangeDate,
            '${group.eventDate.day}.${group.eventDate.month}.${group.eventDate.year}',
            false,
          ),
        ),
      ],
    );
  }

  Widget _buildParticipantsHeader(BuildContext context, GroupEntity group) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              context.loc.participants,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                '${group.participants.length} ${context.loc.elevs}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.surface,
            foregroundColor: Theme.of(context).colorScheme.tertiary,
            side: BorderSide(color: Theme.of(context).colorScheme.tertiary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () => _showAddMoreSheet(context),
          icon: Icon(
            Icons.person_add_alt_1_rounded,
            color: Theme.of(context).colorScheme.tertiary,
            size: 14,
          ),
          label: Text(
            context.loc.addMore.toUpperCase(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              height: 1.0,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Info card (budget / date) – shared with user view via top-level function
// ─────────────────────────────────────────────────────────────────────────────

Widget buildGroupInfoCard(
  BuildContext context,
  String title,
  String value,
  bool isBudget,
) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12),
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isBudget
                ? Icon(
                  Icons.attach_money,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                )
                : Icon(
                  Icons.calendar_month,
                  color: Theme.of(context).colorScheme.tertiary,
                  size: 20,
                ),
            isBudget
                ? Icon(
                  Icons.local_offer_outlined,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.2),
                  size: 26,
                )
                : Icon(
                  Icons.event_available,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.2),
                  size: 26,
                ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            color: AppTheme.slateBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Start Drawing button
// ─────────────────────────────────────────────────────────────────────────────

class _StartDrawingButton extends StatefulWidget {
  const _StartDrawingButton({required this.colorScheme});
  final ColorScheme colorScheme;

  @override
  State<_StartDrawingButton> createState() => _StartDrawingButtonState();
}

class _StartDrawingButtonState extends State<_StartDrawingButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerController;
  late final Animation<double> _shimmerAnimation;
  bool _pressed = false;

  void onPressed() {
    final groupState = context.read<GroupBloc>().state;
    final group = groupState.group;
    if (group == null) return;
    if (group.participantsUIDs.length % 2 != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.loc.evenParticipantsRequired),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }
    if (group.participantsUIDs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.loc.atLeastTwoParticipants)),
      );
      return;
    }
    if (group.participants.values.contains(UserStatus.invited)) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(context.loc.areYouSure),
            content: Text(context.loc.invitedParticipantsWillBeRemoved),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(context.loc.cancel),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  final groupState = context.read<GroupBloc>().state;
                  final group = groupState.group;
                  if (group == null) return;
                  context.read<GroupBloc>().add(
                    UpdateGroupEvent(
                      group.copyWith(
                        participants: Map.fromEntries(
                          group.participants.entries.where(
                            (entry) => entry.value != UserStatus.invited,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: Text(context.loc.yes),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
    _shimmerAnimation = Tween<double>(begin: -1.5, end: 2.5).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = widget.colorScheme.primary;
    final tertiary = widget.colorScheme.tertiary;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () => onPressed(),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          width: double.infinity,
          height: 62,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                primary,
                Color.lerp(primary, tertiary, 0.45)!,
                primary.withValues(alpha: 0.85),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: tertiary.withValues(alpha: 0.7),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: primary.withValues(alpha: 0.45),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: tertiary.withValues(alpha: 0.25),
                blurRadius: 28,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: -18,
                  top: -18,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: tertiary.withValues(alpha: 0.12),
                    ),
                  ),
                ),
                Positioned(
                  right: -10,
                  bottom: -12,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.06),
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: _shimmerAnimation,
                  builder: (context, _) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(_shimmerAnimation.value - 0.4, -1),
                          end: Alignment(_shimmerAnimation.value + 0.4, 1),
                          colors: [
                            Colors.transparent,
                            Colors.white.withValues(alpha: 0.10),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.loc.startDrawing.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.0,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Private helper (used only within this file)
Widget _buildInfoCard(
  BuildContext context,
  String title,
  String value,
  bool isBudget,
) => buildGroupInfoCard(context, title, value, isBudget);
