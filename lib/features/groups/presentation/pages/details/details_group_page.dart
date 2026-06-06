import 'package:flutter/material.dart';
import 'package:secret_santa/core/extensions/context_extension.dart';
import 'package:secret_santa/core/l10n/app_localizations.dart';
import 'package:secret_santa/core/theme/app_theme.dart';
import 'package:secret_santa/core/enums/user_status.dart';
import 'package:secret_santa/features/groups/domain/entities/group_entity.dart';

class DetailsGroupPage extends StatefulWidget {
  const DetailsGroupPage({super.key, required this.group});
  final GroupEntity group;

  @override
  State<DetailsGroupPage> createState() => _DetailsGroupPageState();
}

class _DetailsGroupPageState extends State<DetailsGroupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.loc.groupDetailsAppBarTitle)),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildInfoCard(
                        context,
                        context.loc.budget,
                        "${widget.group.budgetLimit} ${widget.group.currency}",
                        true,
                      ),
                    ),
                    SizedBox(width: MediaQuery.sizeOf(context).width * 0.10),
                    Expanded(
                      child: _buildInfoCard(
                        context,
                        "${context.loc.exchangeDate}",
                        "${widget.group.eventDate.day}.${widget.group.eventDate.month}.${widget.group.eventDate.year}",
                        false,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        context.loc.participants,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
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
                            ).colorScheme.onSurface.withOpacity(0.2),
                          ),
                        ),
                        child: Text(
                          "${widget.group.participants.length} ${context.loc.elevs}",
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
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed:
                        () => print(
                          "add more",
                        ), //TODO: implement page of adding more users
                    icon: Icon(
                      Icons.add,
                      color: Theme.of(context).colorScheme.tertiary,
                      size: 12,
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
              ),
              const SizedBox(height: 16),
              Expanded(child: _buildParticipantsList(context)),
              const SizedBox(height: 16),
              _buildStartDrawingButton(context),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParticipantsList(BuildContext context) {
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
              'Brak uczestników',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Dodaj uczestników, aby rozpocząć losowanie',
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
        return _buildParticipantTile(context, uid, status, isAuthor);
      },
    );
  }
}

Widget _buildInfoCard(
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
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
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

Widget _buildParticipantTile(
  BuildContext context,
  String uid,
  UserStatus status,
  bool isAuthor,
) {
  final statusLabel = _statusLabel(status, context.loc);
  final statusColor = _statusColor(context, status);

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                uid,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isAuthor)
          Icon(
            Icons.remove_circle_outline,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
          ),
      ],
    ),
  );
}

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
      return Colors.green;
    case UserStatus.invited:
      return Colors.blue;
    case UserStatus.pending:
      return Colors.orange;
    case UserStatus.declined:
      return Colors.red;
  }
}

Widget _buildStartDrawingButton(BuildContext context) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: Theme.of(context).colorScheme.tertiary,
            width: 2,
          ),
        ),
      ),
      onPressed: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_awesome,
            color: Theme.of(context).colorScheme.tertiary,
          ),
          const SizedBox(width: 8),
          const Text(
            "START DRAWING",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.auto_awesome,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ],
      ),
    ),
  );
}
