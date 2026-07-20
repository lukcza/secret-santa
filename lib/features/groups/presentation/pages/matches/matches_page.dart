import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:secret_santa/core/enums/group_status.dart';
import 'package:secret_santa/core/extensions/context_extension.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';
import 'package:secret_santa/features/groups/domain/entities/group_entity.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_bloc.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_event.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_state.dart';
import 'package:secret_santa/features/groups/presentation/widgets/match_tile.dart';
import 'package:secret_santa/features/groups/presentation/widgets/outline_button.dart';
import 'package:secret_santa/features/groups/presentation/widgets/confirm_button.dart';
import 'package:secret_santa/features/groups/presentation/pages/details/details_group_page.dart';

class MatchesPage extends StatefulWidget {
  const MatchesPage({
    super.key,
    required this.group,
    required this.participants,
  });
  final GroupEntity group;
  final List<UserEntity> participants;
  @override
  State<MatchesPage> createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  bool _confirming = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _draw());
  }

  void _draw() {
    context.read<GroupBloc>().add(
      DrawPairsLocalEvent(
        participantUids: widget.group.participantsUIDs,
        excludedPairs: widget.group.excludedPairs,
      ),
    );
  }

  void _confirm(Map<String, String> matches) {
    setState(() => _confirming = true);
    context.read<GroupBloc>().add(
      ConfirmDrawEvent(group: widget.group, matches: matches),
    );
  }

  UserEntity? _findUser(String uid) {
    try {
      return widget.participants.firstWhere(
        (u) => u.uid == uid || u.email == uid,
      );
    } catch (_) {
      return null;
    }
  }

  void _openProfile(BuildContext context, UserEntity user) {
    // TODO: nawigacja do profilu użytkownika
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.loc.profileNavigationMock(user.displayName)),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupBloc, GroupState>(
      listener: (context, state) {
        if (state.status == GroupStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Błąd'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          context.pop();
        }
        // Po pomyślnym zatwierdzeniu na serwerze (group.matches niepuste)
        if (_confirming &&
            state.status == GroupStatus.drawn &&
            state.group?.matches.isNotEmpty == true) {
          setState(() => _confirming = false);
          final groupBloc = context.read<GroupBloc>();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) => BlocProvider.value(
                    value: groupBloc,
                    child: DetailsGroupPage(group: state.group!),
                  ),
            ),
          );
          return;
        }
        if (state.status == GroupStatus.error && state.errorMessage != null) {
          setState(() => _confirming = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Theme.of(context).colorScheme.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final matches = state.matches;
        final isError = state.status == GroupStatus.error;
        // Zatwierdzone = pary zapisane na serwerze (group.matches niepuste)
        final confirmed =
            state.status == GroupStatus.drawn &&
            state.group?.matches.isNotEmpty == true;
        return Stack(
          children: [
            Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                scrolledUnderElevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () => context.pop(),
                ),
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    // ── Nagłówki kolumn ──
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 16, 14, 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              context.loc.giversColumnHeader,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.5),
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          // spacer dopasowany do szerokości ikony strzałki w MatchTile
                          const SizedBox(width: 42),
                          Expanded(
                            child: Text(
                              context.loc.receiversColumnHeader,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.5),
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child:
                          isError && matches.isEmpty
                              ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.error_outline_rounded,
                                        size: 56,
                                        color:
                                            Theme.of(context).colorScheme.error,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        state.errorMessage ??
                                            context.loc.failedToDrawPairs,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.error,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      FilledButton.icon(
                                        onPressed: _draw,
                                        icon: const Icon(Icons.refresh_rounded),
                                        label: Text(context.loc.tryAgain),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              : matches.isEmpty
                              ? const Center(child: CircularProgressIndicator())
                              : ListView.builder(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  4,
                                  16,
                                  8,
                                ),
                                itemCount: matches.length,
                                itemBuilder: (context, index) {
                                  final entry = matches.entries.elementAt(
                                    index,
                                  );
                                  final giver = _findUser(entry.key);
                                  final recipient = _findUser(entry.value);
                                  if (giver == null || recipient == null) {
                                    return const SizedBox.shrink();
                                  }
                                  return MatchTile(
                                    giver: giver,
                                    recipient: recipient,
                                    onTapGiver:
                                        () => _openProfile(context, giver),
                                    onTapRecipient:
                                        () => _openProfile(context, recipient),
                                  );
                                },
                              ),
                    ),
                    if (matches.isNotEmpty)
                      _MatchesActions(
                        confirmed: confirmed,
                        onDraw: _draw,
                        onConfirm: () => _confirm(matches),
                      ),
                  ],
                ),
              ),
            ),
            // Ekran ładowania podczas zapisywania na serwerze
            if (_confirming)
              Container(
                color: Colors.black54,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(color: Colors.white),
                      const SizedBox(height: 16),
                      Text(
                        context.loc.savingMatches,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _MatchesActions extends StatefulWidget {
  const _MatchesActions({
    required this.confirmed,
    required this.onDraw,
    required this.onConfirm,
  });
  final bool confirmed;
  final VoidCallback onDraw;
  final VoidCallback onConfirm;
  @override
  State<_MatchesActions> createState() => _MatchesActionsState();
}

class _MatchesActionsState extends State<_MatchesActions>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmer;
  late final Animation<double> _shimmerAnim;
  @override
  void initState() {
    super.initState();
    _shimmer = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
    _shimmerAnim = Tween<double>(
      begin: -1.5,
      end: 2.5,
    ).animate(CurvedAnimation(parent: _shimmer, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _shimmer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(
          top: BorderSide(color: cs.onSurface.withValues(alpha: 0.08)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomOutlineButton(
            label: context.loc.drawAgain,
            icon: Icons.shuffle_rounded,
            onTap: widget.onDraw,
          ),
          const SizedBox(height: 10),
          CustomConfirmButton(
            shimmerAnim: _shimmerAnim,
            confirmed: widget.confirmed,
            onTap: widget.confirmed ? null : widget.onConfirm,
            confirmedLabel: context.loc.confirmedCheck,
            unconfirmedLabel: context.loc.confirmDrawing,
          ),
        ],
      ),
    );
  }
}
