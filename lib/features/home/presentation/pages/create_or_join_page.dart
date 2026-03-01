import 'package:flutter/material.dart';
import 'package:secret_santa/core/extensions/context_extension.dart';
import 'package:secret_santa/features/home/presentation/widgets/decision_card.dart';

class CreateOrJoinPage extends StatelessWidget {
  const CreateOrJoinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.close),
          splashRadius: 24,
          splashColor: Colors.blueGrey.withOpacity(0.2),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                context.loc.letsGetStarted,
                style: Theme.of(
                  context,
                ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                context.loc.hostOrJoin,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 20,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 32),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: DecisionCard(
                  title: context.loc.createNewGroup,
                  description: context.loc.createNewGroupDescription,
                  buttonText: context.loc.getStarted,
                  onTap: () {},
                  cardType: true,
                ),
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: DecisionCard(
                  title: context.loc.joinExistingGroup,
                  description: context.loc.joinExistingGroupDescription,
                  buttonText: context.loc.enterCode,
                  onTap: () {},
                  cardType: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
