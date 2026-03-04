import 'package:flutter/material.dart';
import 'package:secret_santa/core/extensions/context_extension.dart';
import 'package:secret_santa/features/groups/presentation/widgets/group_budget_slider.dart';
import 'package:secret_santa/features/groups/presentation/widgets/group_name_field.dart';

class CreateGroupPage extends StatelessWidget {
  CreateGroupPage({super.key});
  TextEditingController groupNameController = TextEditingController();
  TextEditingController budgetController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Group"), actions: [Text("1/2")]),
      body: Container(
        child: Column(
          children: [
            Row(children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(90),
                ),
              child: Icon(Icons.celebration)
              )]),
            Row(
              children: [
                GroupNameField(
                  labelText: context.loc.groupNameField,
                  hintText: context.loc.groupNameHint,
                  controller: groupNameController,
                ),
              ],
            ),
            Row(
              children: [
                GroupBudgetSlider(
                  controller: budgetController,
                  minLimitText: "0",
                  maxLimitText: "1000",
                  budget: 0,
                  onChanged: (value) {
                    print("Budget changed to $value");
                  },
                  budgetText: context.loc.budgetText,
                ),
              ],
            ),
            Container(
              child: Row(
                children: [
                  Text(context.loc.whoIsInvited),
                  
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
