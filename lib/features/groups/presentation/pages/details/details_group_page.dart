import 'package:flutter/material.dart';
import 'package:secret_santa/core/extensions/context_extension.dart';
import 'package:secret_santa/features/home/domain/entities/group_entity.dart';

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
      appBar: AppBar(title: const Text("Szczegóły grupy")),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildInfoCard(
                      context,
                      context.loc.budget,
                      "${widget.group.budgetLimit} ${widget.group.currency}",
                      true,
                    ),
                  ),
                  const SizedBox(width: 8),
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
          ],
        ),
      ),
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
                  size: 18,
                )
                : Icon(
                  Icons.calendar_month,
                  color: Theme.of(context).colorScheme.tertiary,
                  size: 18,
                ),
            isBudget
                ? Icon(
                  Icons.local_offer_outlined,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.2),
                  size: 24,
                )
                : Icon(
                  Icons.event_available,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.2),
                  size: 24,
                ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
