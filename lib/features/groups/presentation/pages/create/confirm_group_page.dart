import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:secret_santa/core/enums/group_status.dart';
import 'package:secret_santa/core/enums/user_status.dart';
import 'package:secret_santa/core/extensions/context_extension.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_state.dart'
    show GroupState;
import 'package:secret_santa/features/groups/presentation/widgets/group_data_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_bloc.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_event.dart';
import 'package:secret_santa/features/groups/domain/entities/group_entity.dart';
import 'package:secret_santa/features/groups/presentation/pages/details/details_group_page.dart';

class ConfirmGroupPage extends StatefulWidget {
  final String groupName;
  final int budget;
  final DateTime date;
  final List<UserEntity> participants;
  final String authorUID;
  final String currency;
  final VoidCallback? onConfirm;
  final VoidCallback? onAddMore;
  final VoidCallback? onEditOrder;
  final VoidCallback? onEditGroup;

  const ConfirmGroupPage({
    super.key,
    required this.groupName,
    required this.budget,
    required this.date,
    required this.participants,
    required this.authorUID,
    required this.currency,
    this.onConfirm,
    this.onAddMore,
    this.onEditOrder,
    this.onEditGroup,
  });

  @override
  State<ConfirmGroupPage> createState() => _ConfirmGroupPageState();
}

class _ConfirmGroupPageState extends State<ConfirmGroupPage> {
  late List<UserEntity> _participants;
  @override
  void initState() {
    super.initState();
    _participants = List.from(widget.participants);
  }

  void _removeParticipant(int index) {
    setState(() {
      _participants.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupBloc, GroupState>(
      listener: (context, state) {
        if (state.status == GroupStatus.drawn) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.loc.groupDrawnSuccessfully),
              duration: const Duration(seconds: 2),
            ),
          );
          if (state.group != null) {
            final groupBloc = context.read<GroupBloc>();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: groupBloc,
                  child: DetailsGroupPage(group: state.group!),
                ),
              ),
            );
          }
        } else if (state.status == GroupStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.loc.errorPrefix(state.errorMessage ?? '')),
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state.status == GroupStatus.checking) {
          CircularProgressIndicator();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            context.loc.reviewGroupTitle,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                "3/3",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GroupDataCard(
                        groupName: widget.groupName,
                        budget: widget.budget,
                        date: widget.date,
                        membersCount: _participants.length,
                        onEditTap: widget.onEditGroup,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            context.loc.participantsReview,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          TextButton.icon(
                            onPressed: widget.onAddMore,
                            icon: const Icon(
                              Icons.person_add_alt_1_outlined,
                              size: 16,
                            ),
                            label: Text(context.loc.addMore),
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  Theme.of(context).colorScheme.primary,
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(_participants.length, (index) {
                        final participant = _participants[index];
                        return _buildParticipantTile(index, participant);
                      }),
                      const SizedBox(height: 16),
                      _buildEditOrderButton(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '✨',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          context.loc.readyToDrawNames,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '✨',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    BlocBuilder<GroupBloc, GroupState>(
                      builder: (context, state) {
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              context.read<GroupBloc>().add(
                                CreateGroupEvent(
                                  group: GroupEntity(
                                    authorUID: widget.authorUID,
                                    id: '',
                                    title: widget.groupName,
                                    participants: Map.fromEntries(
                                      widget.participants.map(
                                        (e) => MapEntry(
                                          e.uid == '' ? e.email : e.uid,
                                          UserStatus.invited,
                                        ),
                                      ),
                                    ),
                                    participantsUIDs:
                                        widget.participants
                                            .map(
                                              (e) =>
                                                  e.uid == '' ? e.email : e.uid,
                                            )
                                            .toList(),
                                    budgetLimit: widget.budget,
                                    currency: widget.currency,
                                    eventDate: widget.date,
                                    createdAt: DateTime.now(),
                                    inviteCode: state.inviteCode ?? '',
                                    state: state.status,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.check_circle_outline),
                            label: Text(context.loc.confirmGroupCreation),
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParticipantTile(int index, UserEntity participant) {
    final isAdmin = participant.uid == widget.authorUID;
    final bgColor =
        participant.avatarBgColorValue != null
            ? Color(participant.avatarBgColorValue!)
            : const Color(0xFF7A1C1C);
    final fgColor =
        participant.avatarForegroundColorValue != null
            ? Color(participant.avatarForegroundColorValue!)
            : Colors.white;
    final iconData =
        participant.avatarIconCodePoint != null
            ? IconData(
              participant.avatarIconCodePoint!,
              fontFamily: 'MaterialIcons',
            )
            : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.secondaryContainer.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              border: Border.all(color: fgColor, width: 1.5),
            ),
            alignment: Alignment.center,
            child:
                iconData != null
                    ? Icon(iconData, color: fgColor, size: 20)
                    : Text(
                      participant.initials,
                      style: TextStyle(
                        color: fgColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      participant.displayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    if (isAdmin) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          context.loc.host.toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFF2E1500),
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  participant.email,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          if (!isAdmin)
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: Theme.of(context).colorScheme.secondaryContainer,
                size: 20,
              ),
              onPressed: () => _removeParticipant(index),
            ),
        ],
      ),
    );
  }

  Widget _buildEditOrderButton() {
    return CustomPaint(
      painter: _DashedRectPainter(
        color: Theme.of(
          context,
        ).colorScheme.secondaryContainer.withValues(alpha: 0.4),
        strokeWidth: 1,
        gap: 4,
        radius: 16,
      ),
      child: InkWell(
        onTap: widget.onEditOrder,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.reorder,
                size: 18,
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
              const SizedBox(width: 8),
              Text(
                context.loc.editListOrder,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double radius;

  _DashedRectPainter({
    this.color = Colors.black,
    this.strokeWidth = 1.0,
    this.gap = 5.0,
    this.radius = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    final Path path = Path()..addRRect(rrect);

    final Path dashedPath = Path();
    double distance = 0.0;
    bool draw = true;

    for (final PathMetric measurePath in path.computeMetrics()) {
      while (distance < measurePath.length) {
        final double len = draw ? gap : gap;
        if (draw) {
          dashedPath.addPath(
            measurePath.extractPath(distance, distance + len),
            Offset.zero,
          );
        }
        distance += len;
        draw = !draw;
      }
    }

    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
