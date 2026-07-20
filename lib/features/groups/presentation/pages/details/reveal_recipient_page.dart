import 'package:flutter/material.dart';
import 'package:secret_santa/core/extensions/context_extension.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';
import 'package:go_router/go_router.dart';

class RevealRecipientPage extends StatefulWidget {
  const RevealRecipientPage({
    super.key,
    required this.recipient,
    required this.groupId,
  });

  final UserEntity recipient;
  final String groupId;

  @override
  State<RevealRecipientPage> createState() => _RevealRecipientPageState();
}

class _RevealRecipientPageState extends State<RevealRecipientPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Delikatne pulsowanie na napisie "Ho Ho Ho!"
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutSine,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Stack(
          children: [
            // Subtelne tło z cząsteczkami (na razie zrobimy prosty wzór lub puste)
            Positioned.fill(
              child: Opacity(
                opacity: 0.05,
                child: Image.asset(
                  'assets/images/cardBGCreate.png', // użyjmy istniejącego tła
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            Column(
              children: [
                // AppBar (custom)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white70, size: 20),
                          onPressed: () => context.pop(),
                        ),
                      ),
                      Text(
                        context.loc.secretSantaUpper,
                        style: TextStyle(
                          color: cs.tertiary, // Żółty / złoty
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Ho Ho Ho! (z delikatnym pulsowaniem)
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Text(
                    context.loc.hoHoHo,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFFFF3B30),
                      shadows: [
                        Shadow(
                          color: const Color(0xFFFF3B30).withValues(alpha: 0.6),
                          blurRadius: 20,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 8),
                Text(
                  context.loc.youAreSecretSantaFor,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 40),

                // Główna karta
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: [
                        // Tło karty
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 24),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1C1A17), // Ciemno szary
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: cs.tertiary.withValues(alpha: 0.3),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.5),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Spacer(),
                              
                              // Awatar (wyśrodkowany)
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.transparent,
                                  boxShadow: [
                                    BoxShadow(
                                      color: cs.tertiary.withValues(alpha: 0.4),
                                      blurRadius: 25,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: cs.tertiary, width: 3),
                                  ),
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      CircleAvatar(
                                        radius: 56,
                                        backgroundColor: widget.recipient.avatarBgColorValue != null 
                                            ? Color(widget.recipient.avatarBgColorValue!) 
                                            : cs.primary,
                                        backgroundImage: widget.recipient.photoUrl != null
                                            ? NetworkImage(widget.recipient.photoUrl!)
                                            : null,
                                        child: widget.recipient.photoUrl == null
                                            ? Text(
                                                widget.recipient.initials,
                                                style: TextStyle(
                                                  fontSize: 36,
                                                  fontWeight: FontWeight.bold,
                                                  color: widget.recipient.avatarForegroundColorValue != null
                                                      ? Color(widget.recipient.avatarForegroundColorValue!)
                                                      : Colors.white,
                                                ),
                                              )
                                            : null,
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE53935),
                                            shape: BoxShape.circle,
                                            border: Border.all(color: const Color(0xFF1C1A17), width: 2),
                                          ),
                                          child: const Icon(Icons.check, size: 16, color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 16),
                              
                              // Imię
                              Text(
                                widget.recipient.displayName,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                              
                              const Spacer(),
                              
                              // Przycisk
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: FilledButton.icon(
                                  onPressed: () => context.pop(), // Zamyka Reveal, pokazuje Wishlist
                                  icon: const Icon(Icons.card_giftcard_rounded),
                                  label: Text(
                                    context.loc.viewTheirWishlist,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: const Color(0xFFE53935),
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size(double.infinity, 56),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Footer text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.schedule, size: 14, color: cs.tertiary),
                    const SizedBox(width: 6),
                    Text(
                      context.loc.makeSureToGetSomethingNice,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
