import 'package:flutter/material.dart';
import 'package:secret_santa/core/extensions/context_extension.dart';
import 'package:secret_santa/core/l10n/app_localizations.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';
import 'package:secret_santa/features/groups/domain/entities/group_entity.dart';
import 'package:secret_santa/features/groups/presentation/widgets/participant_tile.dart';

class ParticipantsList extends StatefulWidget {
  const ParticipantsList({super.key, required this.group, required this.users});

  final GroupEntity group;
  final List<UserEntity> users;

  @override
  State<ParticipantsList> createState() => _ParticipantsListState();
}

class _ParticipantsListState extends State<ParticipantsList>
    with TickerProviderStateMixin {
  late final AnimationController _showConfigController;
  late final Animation<double> _showConfigAnimation;
  String? _expandedUid;

  @override
  void initState() {
    super.initState();
    _showConfigController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _showConfigAnimation = Tween<double>(begin: 0.08, end: 1.0).animate(
      CurvedAnimation(parent: _showConfigController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _showConfigController.dispose();
    super.dispose();
  }

  void toggleShowConfig(String uid) {
    if (_showConfigController.isAnimating) {
      return;
    }
    if (_expandedUid == uid) {
      _showConfigController.reverse();
      setState(() => _expandedUid = null);
    } else {
      _showConfigController.forward(from: 0);
      setState(() => _expandedUid = uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final participants = widget.group.participants;
    if (participants.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.group_off_outlined,
              size: 56,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.25),
            ),
            const SizedBox(height: 12),
            Text(
              context.loc.noParticipants,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              context.loc.addParticipantsToStart,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
              ),
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      itemCount: participants.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final uid = participants.keys.elementAt(index);
        final status = participants.values.elementAt(index);
        final isAuthor = uid == widget.group.authorUID;
        final participant = widget.users.firstWhere(
          (u) => u.uid == uid,
          orElse:
              () => UserEntity(uid: uid, email: uid.contains('@') ? uid : ''),
        );

        return ParticipantTile(
          uid: uid,
          status: status,
          isAuthor: isAuthor,
          group: widget.group,
          animation: _showConfigAnimation,
          isExpanded: _expandedUid == uid,
          onTap: () => toggleShowConfig(uid),
          users: widget.users,
          participant: participant,
        );
      },
    );
  }
}
