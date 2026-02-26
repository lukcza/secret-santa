import 'package:flutter/material.dart';
import 'package:secret_santa/core/extensions/context_extension.dart';

class AddGroupPlaceholder extends StatefulWidget {
  const AddGroupPlaceholder({super.key});

  @override
  State<AddGroupPlaceholder> createState() => _AddGroupPlaceholderState();
}

class _AddGroupPlaceholderState extends State<AddGroupPlaceholder> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      color: Theme.of(context).colorScheme.primary,
      child: InkWell(
        onTap: () => print("Add group tapped"),
        child: Container(
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            //color: Theme.of(context).colorScheme.background.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withAlpha(250),
              width: 2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_outline,
                size: 40,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              const SizedBox(width: 8),
              Text(
                context.loc.createNewGroup,
                style: TextStyle(
                  fontSize: 17,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
