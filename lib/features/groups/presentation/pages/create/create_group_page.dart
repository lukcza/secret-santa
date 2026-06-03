import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocProvider, ReadContext;
import 'package:secret_santa/core/extensions/context_extension.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_bloc.dart';
import 'package:secret_santa/features/groups/presentation/pages/create/confirm_group_page.dart';
import 'package:secret_santa/features/groups/presentation/pages/create/manually_invite_page.dart';
import 'package:secret_santa/features/groups/presentation/widgets/add_friends_list_tile.dart';
import 'package:secret_santa/features/groups/presentation/widgets/added_counter.dart';
import 'package:secret_santa/features/groups/presentation/widgets/group_budget_slider.dart';
import 'package:secret_santa/features/groups/presentation/widgets/group_name_field.dart';

class CreateGroupPage extends StatefulWidget {
  final DateTime selectedDate;

  const CreateGroupPage({super.key, required this.selectedDate});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  late TextEditingController groupNameController;
  late TextEditingController budgetController;
  late String currency;
  double budget = 25.0;
  final List<UserEntity> _participants = [];
  late UserEntity user;

  @override
  void initState() {
    super.initState();
    groupNameController = TextEditingController();
    budgetController = TextEditingController(text: "25");
    currency = "USD";
    user = context.read<AuthBloc>().state.user!;
    _participants.add(
      UserEntity(
        uid: user.uid,
        email: user.email,
        nickname: user.displayName,
        avatarBgColorValue: const Color(0xFF3D1515).toARGB32(),
        avatarForegroundColorValue: const Color(0xFFD32F2F).toARGB32(),
      ),
    );
  }

  @override
  void dispose() {
    groupNameController.dispose();
    budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.loc.createGroup,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Text(
              "2/3",
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
                      onCurrencyChanged:
                          (currency) => setState(() {
                            this.currency = currency;
                          }),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Text(
                          context.loc.whoIsInvited,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        AddedCounter(addedFriends: _participants.length),
                      ],
                    ),
                    const SizedBox(height: 12),
                    AddFriendsListTile(
                      title: context.loc.addFirendsManually,
                      subtitle: context.loc.inputNameAndEmail,
                      icon: Icons.person_add_alt_1_rounded,
                      iconColor: Theme.of(context).colorScheme.primary,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => BlocProvider.value(
                                  value: context.read<GroupBloc>(),
                                  child: const ManuallyInvitePage(),
                                ),
                          ),
                        );
                      },
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
                    const SizedBox(height: 16),
                    if (_participants.isEmpty) ...[
                      const SizedBox(height: 20),
                      Center(
                        child: Column(
                          children: [
                            const Icon(
                              Icons.groups_3,
                              size: 40,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              context.loc.yourElfSquadIsEmpty,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      const SizedBox(height: 8),
                      ..._participants.map((p) => _buildParticipantTile(p)),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.loc.letsGetStarted.toUpperCase(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final name = groupNameController.text.trim();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (routeContext) => BlocProvider.value(
                                  value: context.read<GroupBloc>(),
                                  child: ConfirmGroupPage(
                                    groupName:
                                        name.isNotEmpty
                                            ? name
                                            : "Secret Santa Group",
                                    budget: budget.toInt(),
                                    date: widget.selectedDate,
                                    participants: _participants,
                                    authorUID: user.uid,
                                    currency: currency,
                                    onConfirm: () {},
                                    onAddMore: () {
                                      Navigator.pop(routeContext);
                                    },
                                    onEditOrder: () {},
                                    onEditGroup: () {
                                      Navigator.pop(routeContext);
                                    },
                                  ),
                                ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.arrow_forward),
                      label: Text(context.loc.nextStep),
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddFriendDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(context.loc.addFirendsManually),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: context.loc.nameLabel,
                    hintText: 'Enter name',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return context.loc.nameRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: context.loc.emailFieldLabel,
                    hintText: context.loc.emailFieldHint,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return context.loc.emailRequired;
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value.trim())) {
                      return context.loc.emailInvalid;
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final newFriend = UserEntity(
                    uid: DateTime.now().millisecondsSinceEpoch.toString(),
                    email: emailController.text.trim(),
                    nickname: nameController.text.trim(),
                    avatarBgColorValue: const Color(0xFF7A1C1C).toARGB32(),
                    avatarForegroundColorValue: Colors.white.toARGB32(),
                  );
                  setState(() {
                    _participants.add(newFriend);
                  });
                  Navigator.pop(context);
                }
              },
              child: Text(context.loc.inviteButton),
            ),
          ],
        );
      },
    );
  }

  Widget _buildParticipantTile(UserEntity participant) {
    final isAdmin = participant.uid == 'admin_uid';
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
                        child: const Text(
                          'HOST',
                          style: TextStyle(
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
              onPressed: () {
                setState(() {
                  _participants.remove(participant);
                });
              },
            ),
        ],
      ),
    );
  }
}
