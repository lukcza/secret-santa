import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_santa/core/extensions/context_extension.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';
import 'package:secret_santa/features/groups/domain/entities/group_entity.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_bloc.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_event.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_state.dart';
import 'package:secret_santa/features/groups/presentation/pages/details/details_group_admin.dart'
    show buildGroupInfoCard;
import 'package:go_router/go_router.dart';

class DetailsGroupUser extends StatefulWidget {
  const DetailsGroupUser({
    super.key,
    required this.group,
    required this.currentUid,
  });

  final GroupEntity group;
  final String currentUid;

  @override
  State<DetailsGroupUser> createState() => _DetailsGroupUserState();
}

class _DetailsGroupUserState extends State<DetailsGroupUser>
    with SingleTickerProviderStateMixin {
  List<UserEntity> participants = [];
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    context.read<GroupBloc>().add(
      GetGroupParticipantsEvent(groupId: widget.group.id),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  UserEntity? _findUser(String uid) {
    try {
      return participants.firstWhere((u) => u.uid == uid || u.email == uid);
    } catch (_) {
      return null;
    }
  }

  void _showMessageSheet(BuildContext context, UserEntity recipient) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.lock_rounded,
                        size: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.loc.sendAnonymousMessage,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            context.loc.yourSecretRecipient,
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: controller,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: context.loc.sendAnonymousMessageHint,
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(context.loc.messageSentMock),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.send_rounded, size: 18),
                    label: Text(context.loc.send),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
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
    return BlocConsumer<GroupBloc, GroupState>(
      listener: (context, state) {
        if (state.participants.isNotEmpty) {
          setState(() => participants = state.participants);
        }
      },
      builder: (context, state) {
        final group = state.group ?? widget.group;
        final hasMatches = group.matches.isNotEmpty;
        final recipientUid = group.matches[widget.currentUid];
        final recipient = recipientUid != null ? _findUser(recipientUid) : null;

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            context.go('/');
          },
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: AppBar(
              backgroundColor: hasMatches ? Colors.transparent : null,
              elevation: 0,
              centerTitle: false,
              title: hasMatches ? null : Text(group.title),
              actions: hasMatches 
                ? [
                    IconButton(
                      icon: const Icon(Icons.more_horiz),
                      onPressed: () {
                        // Opcje (np. wyjście)
                      },
                    )
                  ]
                : null,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go('/'),
              ),
            ),
            body: SafeArea(
              child: hasMatches && recipient != null
                  ? _buildWishlistView(context, group, recipient)
                  : _buildWaitingView(context, group),
            ),
          ),
        );
      },
    );
  }

  // ── A) Waiting room ──────────────────────────────────────────────────────

  Widget _buildWaitingView(BuildContext context, GroupEntity group) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          const SizedBox(height: 12),
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
              SizedBox(width: MediaQuery.sizeOf(context).width * 0.10),
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
          const SizedBox(height: 20),
          _buildWaitingCard(context, group),
          const SizedBox(height: 20),
          _buildReadonlyParticipantsList(context, group),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildWaitingCard(BuildContext context, GroupEntity group) {
    final cs = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(scale: _pulseAnimation.value, child: child);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              cs.primary.withValues(alpha: 0.12),
              cs.tertiary.withValues(alpha: 0.07),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: cs.primary.withValues(alpha: 0.25)),
        ),
        child: Column(
          children: [
            const Text('🎄', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(
              context.loc.waitingForDraw,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.loc.waitingForDrawSub,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: cs.onSurface.withValues(alpha: 0.55),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${group.eventDate.day}.${group.eventDate.month}.${group.eventDate.year}',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: cs.tertiary,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── B) Wishlist (Po losowaniu) ──────────────────────────────────────────

  Widget _buildWishlistView(BuildContext context, GroupEntity group, UserEntity recipient) {
    final cs = Theme.of(context).colorScheme;
    
    // Zmockowane przedmioty (do czasu integracji z bazą)
    final wishlistItems = [
      {
        'title': context.loc.mockItemMugTitle,
        'price': '25.00',
        'desc': context.loc.mockItemMugDesc,
        'priority': context.loc.highPriority,
        'isHighPriority': true,
        'icon': Icons.coffee,
      },
      {
        'title': context.loc.mockItemBookTitle,
        'price': '18.50',
        'desc': 'Hardcover ${context.loc.preferred}',
        'priority': null,
        'isHighPriority': false,
        'icon': Icons.book,
      },
      {
        'title': context.loc.mockItemYarnTitle,
        'price': '12.00',
        'desc': context.loc.mockItemYarnDesc,
        'priority': null,
        'isHighPriority': false,
        'icon': Icons.texture,
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          
          // Awatar
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF9800).withValues(alpha: 0.4),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: recipient.avatarBgColorValue != null
                      ? Color(recipient.avatarBgColorValue!)
                      : cs.primary,
                  backgroundImage: recipient.photoUrl != null
                      ? NetworkImage(recipient.photoUrl!)
                      : null,
                  child: recipient.photoUrl == null
                      ? Text(
                          recipient.initials,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: recipient.avatarForegroundColorValue != null
                                ? Color(recipient.avatarForegroundColorValue!)
                                : Colors.white,
                          ),
                        )
                      : null,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B2220),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF161211), width: 3),
                  ),
                  child: const Icon(Icons.campaign, size: 16, color: Color(0xFFE53935)),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Tytuł
          Text(
            '${recipient.displayName}${context.loc.wishlistSuffix}',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            context.loc.youAreTheirSecretSanta,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFFE53935),
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Budget & Message
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B281B), // Ciemnozielone tło
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF2E7D32).withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.payments, size: 16, color: Color(0xFF4CAF50)),
                    const SizedBox(width: 8),
                    Text(
                      '${context.loc.budgetPrefix} ${group.budgetLimit} ${group.currency}',
                      style: const TextStyle(
                        color: Color(0xFF4CAF50),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Przycisk wysyłania wiadomości (jak na designie)
              Container(
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.chat_bubble_rounded, color: cs.primary, size: 20),
                  onPressed: () => _showMessageSheet(context, recipient),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Top Picks Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.star_rounded, color: cs.tertiary, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    context.loc.topPicks,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Text(
                context.loc.itemsCount(wishlistItems.length).toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Lista przedmiotów
          ...wishlistItems.map((item) => _buildWishlistItemCard(context, item, group.currency)).toList(),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }
  
  Widget _buildWishlistItemCard(BuildContext context, Map<String, dynamic> item, String currency) {
    final bool isHighPriority = item['isHighPriority'];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF251918), // Bardzo ciemny czerwono-brązowy
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Obrazek zastępczy
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1312),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(item['icon'], size: 36, color: Colors.white54),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isHighPriority) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item['priority'],
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item['title'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      '${item['price']} $currency',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE53935),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (!isHighPriority && item['desc'].contains('preferred'))
                      const Icon(Icons.info_outline, size: 12, color: Color(0xFF4CAF50)),
                    if (!isHighPriority && item['desc'].contains('preferred'))
                      const SizedBox(width: 4),
                    Text(
                      item['desc'],
                      style: TextStyle(
                        fontSize: 12,
                        color: !isHighPriority && item['desc'].contains('preferred')
                            ? const Color(0xFF4CAF50)
                            : Colors.white54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.chat_bubble_outline, size: 20, color: Colors.white54),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3E2723), // Lekko jaśniejszy brązowo-czerwony
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Text(
                            context.loc.viewOnline,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.open_in_new, size: 14, color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Readonly lista uczestników (Waiting room) ────────────────────────
  Widget _buildReadonlyParticipantsList(
    BuildContext context,
    GroupEntity group,
  ) {
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
                border: Border.all(
                  color: cs.onSurface.withValues(alpha: 0.2),
                ),
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
          final avatarBg =
              user?.avatarBgColorValue != null
                  ? Color(user!.avatarBgColorValue!)
                  : cs.primary.withValues(alpha: 0.65);
          final avatarFg =
              user?.avatarForegroundColorValue != null
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
                  backgroundImage:
                      user?.photoUrl != null
                          ? NetworkImage(user!.photoUrl!)
                          : null,
                  child:
                      user?.photoUrl == null
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
                    isMe ? '$displayName ${context.loc.meSuffix}' : displayName,
                    style: TextStyle(
                      fontWeight:
                          isMe ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
