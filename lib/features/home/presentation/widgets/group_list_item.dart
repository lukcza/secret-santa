import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:secret_santa/core/enums/group_status.dart';
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
                      GroupStatus.draft => Icons.edit,
                      GroupStatus.recruiting => Icons.check,
                      GroupStatus.drawn => Icons.hourglass_bottom,
                      GroupStatus.active => Icons.check_circle,
                      GroupStatus.finished => Icons.done_all,
                      // TODO: Handle this case.
                      GroupStatus.error => throw UnimplementedError(),
                    },
                    color: switch (widget.group.state) {
                      GroupStatus.draft => Colors.blueAccent,
                      GroupStatus.recruiting =>
                        Theme.of(context).colorScheme.tertiary,
                      GroupStatus.drawn =>
                        Theme.of(context).colorScheme.secondary,
                      GroupStatus.active =>
                        Theme.of(context).colorScheme.secondary,
                      GroupStatus.finished =>
                        Theme.of(context).colorScheme.onPrimary,
                      // TODO: Handle this case.
                      GroupStatus.error => throw UnimplementedError(),
                    },
                  ),
                  Text(
                    switch (widget.group.state) {
                      GroupStatus.draft => context.loc.rdyToStartRecruting,
                      GroupStatus.recruiting => context.loc.elvesRecruting,
                      GroupStatus.drawn => context.loc.drawingComplete,
                      GroupStatus.active => context.loc.elvesAreHelpingSanta,
                      GroupStatus.finished => context.loc.evryoneGotAPresents,
                      // TODO: Handle this case.
                      GroupStatus.error => throw UnimplementedError(),
                    },
                    style: TextStyle(
                      color: switch (widget.group.state) {
                        GroupStatus.draft => Colors.blueAccent,
                        GroupStatus.recruiting =>
                          Theme.of(context).colorScheme.tertiary,
                        GroupStatus.drawn =>
                          Theme.of(context).colorScheme.secondary,
                        GroupStatus.active =>
                          Theme.of(context).colorScheme.secondary,
                        GroupStatus.finished =>
                          Theme.of(context).colorScheme.onPrimary,
                        // TODO: Handle this case.
                        GroupStatus.error => throw UnimplementedError(),
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
