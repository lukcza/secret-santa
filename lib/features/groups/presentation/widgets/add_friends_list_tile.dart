import 'package:flutter/material.dart';

class AddFriendsListTile extends StatelessWidget {
  const AddFriendsListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  final Color? iconColor;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).inputDecorationTheme.fillColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.secondaryContainer,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: CircleAvatar(
            backgroundColor: Theme.of(
              context,
            ).colorScheme.secondaryContainer.withOpacity(0.2),
            child: Icon(
              icon,
              color: iconColor,
            ),
          ),
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
            ),
          subtitle: 
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12,              
                  color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
                ),
            ),
          trailing: Transform.flip(
            flipX: true,
            flipY: true,
            child: Icon(
              Icons.arrow_back_ios,
              size: 16,
              color: Theme.of(context).colorScheme.secondaryContainer,
            ),
          ),
        ),
      ),
    );
  }
}
