import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_bloc.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_state.dart';
import 'package:secret_santa/features/groups/presentation/pages/details/details_group_admin.dart';
import 'package:secret_santa/features/groups/presentation/pages/details/details_group_hub_page.dart';

/// Punkt wejścia do widoku szczegółów grupy.
/// Grupę pobiera ze stanu [GroupBloc] (zasilony przez [GetGroupEvent]).
/// Na podstawie tego czy bieżący użytkownik jest twórcą grupy
/// renderuje [DetailsGroupAdmin] lub [DetailsGroupHubPage].
class DetailsGroupPage extends StatelessWidget {
  const DetailsGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupBloc, GroupState>(
      builder: (context, state) {
        final group = state.group;

        if (group == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final authState = context.read<AuthBloc>().state;
        final currentUid = authState.user?.uid ?? '';
        final currentUser = authState.user;
        final isAdmin = group.authorUID == currentUid;

        if (isAdmin) {
          return DetailsGroupAdmin(group: group);
        } else if (currentUser != null) {
          return DetailsGroupHubPage(
            group: group,
            currentUid: currentUid,
            currentUser: currentUser,
          );
        } else {
          return DetailsGroupAdmin(group: group); // fallback
        }
      },
    );
  }
}
