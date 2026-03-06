import 'package:flutter/material.dart';
import 'package:secret_santa/core/extensions/context_extension.dart';
import 'package:secret_santa/features/groups/presentation/widgets/add_friends_list_tile.dart';
import 'package:secret_santa/features/groups/presentation/widgets/added_counter.dart';
import 'package:secret_santa/features/groups/presentation/widgets/group_budget_slider.dart';
import 'package:secret_santa/features/groups/presentation/widgets/group_name_field.dart';

class CreateGroupPage extends StatefulWidget {
  CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  late TextEditingController groupNameController;
  late TextEditingController budgetController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    groupNameController = TextEditingController();
    budgetController = TextEditingController();
  }

  void dispose() {
    groupNameController.dispose();
    budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.createGroup),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "2/3",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            children: [
              GroupNameField(
                labelText: context.loc.groupNameField,
                hintText: context.loc.groupNameHint,
                controller: groupNameController,
              ),
              const SizedBox(height: 18),
              GroupBudgetSlider(
                controller: budgetController,
                minLimitText: "0",
                maxLimitText: "1000",
                budget: 0,
                onChanged: (value) => print("Budget changed to $value"),
                budgetText: context.loc.budgetText,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    context.loc.whoIsInvited,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  AddedCounter(addedFriends: 0),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      AddFriendsListTile(
                        title: context.loc.addFirendsManually,
                        subtitle: context.loc.inputNameAndEmail,
                        icon: Icons.person_add_alt_1_rounded,
                        iconColor: Theme.of(context).colorScheme.primary,
                        onTap: () {},
                      ),
                      const SizedBox(height: 12),
                      AddFriendsListTile(
                        title: context.loc.selectFromFriends,
                        subtitle: context.loc.quickAddFromContacts,
                        icon: Icons.favorite,
                        iconColor: Theme.of(context).colorScheme.tertiary,
                        onTap: () {},
                      ),
                      const SizedBox(height: 12),
                      AddFriendsListTile(
                        title: context.loc.importFromPast,
                        subtitle: context.loc.reuseAPreviousGroupList,
                        icon: Icons.history,
                        iconColor: Colors.grey,
                        onTap: () {},
                      ),
                      const SizedBox(height: 20),
                      Icon(Icons.groups_3, size: 40, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        context.loc.yourElfSquadIsEmpty,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => print("dsaf"),
                  child: Text(context.loc.nextStep),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
