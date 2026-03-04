import 'package:flutter/material.dart';
import 'package:secret_santa/core/extensions/context_extension.dart';

class AddedCounter extends StatefulWidget {
  const AddedCounter({super.key, required this.addedFriends});
  final int addedFriends;
  @override
  State<AddedCounter> createState() => _AddedCounterState();
}

class _AddedCounterState extends State<AddedCounter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withAlpha(150),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withAlpha(200),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 4,
            offset: const Offset(0, 2), 
          ),
        ],
      ),
      child: Text(
        widget.addedFriends.toString() + " " + context.loc.added,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
