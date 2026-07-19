import 'package:flutter/material.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';
import 'package:secret_santa/features/groups/presentation/widgets/match_tile.dart';
import 'package:widgetbook/widgetbook.dart';

// ── Mock users ─────────────────────────────────────────────────────────────────

const _alice = UserEntity(
  uid: 'user_alice',
  email: 'alice@example.com',
  nickname: 'Alice Kowalska',
  avatarBgColorValue: 0xFFD32F2F,
  avatarForegroundColorValue: 0xFFFFFFFF,
);

const _bob = UserEntity(
  uid: 'user_bob',
  email: 'bob@example.com',
  nickname: 'Bob Nowak',
  avatarBgColorValue: 0xFF1565C0,
  avatarForegroundColorValue: 0xFFFFFFFF,
);

const _carol = UserEntity(
  uid: 'user_carol',
  email: 'carol@example.com',
  nickname: 'Carol Wójcik',
  avatarBgColorValue: 0xFF2E7D32,
  avatarForegroundColorValue: 0xFFFFFFFF,
);

const _dave = UserEntity(
  uid: 'user_dave',
  email: 'dave@example.com',
  nickname: 'Dave Malinowski',
  avatarBgColorValue: 0xFF6A1B9A,
  avatarForegroundColorValue: 0xFFFFFFFF,
);

const _noAvatar = UserEntity(
  uid: 'user_no_avatar',
  email: 'noavatar@example.com',
  // no nickname → displayName falls back to 'noavatar'
);

// ── Use-cases ──────────────────────────────────────────────────────────────────

final matchTileComponent = WidgetbookComponent(
  name: 'MatchTile',
  useCases: [
    // 1. Interactive knobs
    WidgetbookUseCase(
      name: 'Interactive (Knobs)',
      builder: (context) {
        final giverName = context.knobs.string(
          label: 'Giver nickname',
          initialValue: 'Alice Kowalska',
        );
        final recipientName = context.knobs.string(
          label: 'Recipient nickname',
          initialValue: 'Bob Nowak',
        );
        final showPhoto = context.knobs.boolean(
          label: 'Show photo URL',
          initialValue: false,
        );

        final giver = UserEntity(
          uid: 'g',
          email: 'giver@example.com',
          nickname: giverName,
          avatarBgColorValue: 0xFFD32F2F,
          photoUrl: showPhoto
              ? 'https://i.pravatar.cc/150?img=3'
              : null,
        );
        final recipient = UserEntity(
          uid: 'r',
          email: 'recipient@example.com',
          nickname: recipientName,
          avatarBgColorValue: 0xFF1565C0,
          photoUrl: showPhoto
              ? 'https://i.pravatar.cc/150?img=7'
              : null,
        );

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: MatchTile(
              giver: giver,
              recipient: recipient,
              onTapGiver: () {},
              onTapRecipient: () {},
            ),
          ),
        );
      },
    ),

    // 2. Alice → Bob
    WidgetbookUseCase(
      name: 'Alice → Bob',
      builder: (context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: MatchTile(
            giver: _alice,
            recipient: _bob,
            onTapGiver: () {},
            onTapRecipient: () {},
          ),
        ),
      ),
    ),

    // 3. Long names (overflow test)
    WidgetbookUseCase(
      name: 'Long names (overflow)',
      builder: (context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: MatchTile(
            giver: const UserEntity(
              uid: 'g2',
              email: 'very.long.email@company-name.example.com',
              nickname: 'Bartłomiej Przybyszewski',
              avatarBgColorValue: 0xFFE65100,
            ),
            recipient: const UserEntity(
              uid: 'r2',
              email: 'another.very.long.email@example.com',
              nickname: 'Małgorzata Zielińska-Kowalczyk',
              avatarBgColorValue: 0xFF00838F,
            ),
            onTapGiver: () {},
            onTapRecipient: () {},
          ),
        ),
      ),
    ),

    // 4. No nicknames (email fallback)
    WidgetbookUseCase(
      name: 'No nickname (email fallback)',
      builder: (context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: MatchTile(
            giver: _noAvatar,
            recipient: const UserEntity(
              uid: 'r3',
              email: 'someone@example.com',
            ),
            onTapGiver: () {},
            onTapRecipient: () {},
          ),
        ),
      ),
    ),

    // 5. Full list (4 pairs)
    WidgetbookUseCase(
      name: 'Full list (4 pairs)',
      builder: (context) => Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            MatchTile(giver: _alice, recipient: _bob),
            MatchTile(giver: _bob, recipient: _carol),
            MatchTile(giver: _carol, recipient: _dave),
            MatchTile(giver: _dave, recipient: _alice),
          ],
        ),
      ),
    ),
  ],
);
