import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:secret_santa/core/enums/group_state.dart';
import 'package:secret_santa/core/extensions/context_extension.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';
import 'package:secret_santa/features/home/domain/entities/group_entity.dart';

class GroupListItem extends StatefulWidget {
  const GroupListItem({super.key, required this.group, required this.user});
  final GroupEntity group;
  final UserEntity user;
  @override
  State<GroupListItem> createState() => _GroupListItemState();
}

class _GroupListItemState extends State<GroupListItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    switch (widget.group.state) {
                      GroupState.draft => Icons.edit,
                      GroupState.recruiting => Icons.check,
                      GroupState.drawn => Icons.hourglass_bottom,
                      GroupState.active => Icons.check_circle,
                      GroupState.finished => Icons.done_all,
                    },
                    color: switch (widget.group.state) {
                      GroupState.draft => Colors.blueAccent,
                      GroupState.recruiting =>
                        Theme.of(context).colorScheme.tertiary,
                      GroupState.drawn =>
                        Theme.of(context).colorScheme.secondary,
                      GroupState.active =>
                        Theme.of(context).colorScheme.secondary,
                      GroupState.finished =>
                        Theme.of(context).colorScheme.onPrimary,
                    },
                  ),
                  Text(
                    switch (widget.group.state) {
                      GroupState.draft => context.loc.rdyToStartRecruting,
                      GroupState.recruiting => context.loc.elvesRecruting,
                      GroupState.drawn => context.loc.drawingComplete,
                      GroupState.active => context.loc.elvesAreHelpingSanta,
                      GroupState.finished => context.loc.evryoneGotAPresents,
                    },
                    style: TextStyle(
                      color: switch (widget.group.state) {
                        GroupState.draft => Colors.blueAccent,
                        GroupState.recruiting =>
                          Theme.of(context).colorScheme.tertiary,
                        GroupState.drawn =>
                          Theme.of(context).colorScheme.secondary,
                        GroupState.active =>
                          Theme.of(context).colorScheme.secondary,
                        GroupState.finished =>
                          Theme.of(context).colorScheme.onPrimary,
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.group.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.people),
                  Text(
                    "${widget.group.participantsUIDs.length} ${context.loc.participantsJoined}",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      widget.user.uid == widget.group.authorUID
                          ? context.loc.editGroup
                          : context.loc.viewMatch,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon( Icons.calendar_month, color: Theme.of(context).colorScheme.primary, size: 20,),
            ],
          )
        ],
      ),
    );
  }
}
