import 'package:flutter/material.dart';
import 'package:secret_santa/core/extensions/context_extension.dart';
import 'package:secret_santa/features/auth/presentation/widgets/auth_field.dart';

class ManuallyInvitePage extends StatefulWidget {
  const ManuallyInvitePage({super.key});

  @override
  State<ManuallyInvitePage> createState() => _ManuallyInvitePageState();
}

class _ManuallyInvitePageState extends State<ManuallyInvitePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manually Invite')),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.loc.manuallyInviteTitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                context.loc.manuallyInviteSubtitle,
                softWrap: true,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurfaceVariant.withOpacity(0.6),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 3,
                    child: AuthField(
                      controller: TextEditingController(),
                      hintText: context.loc.emailFieldHint,
                      labelText: context.loc.emailFieldLabel,
                      isEmailField: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () => print("invite button clicked"),
                      child: Text(context.loc.inviteButton),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
