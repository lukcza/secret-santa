import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:secret_santa/features/groups/domain/entities/group_entity.dart';
import 'package:secret_santa/features/groups/presentation/pages/details/details_group_admin.dart';
import 'package:secret_santa/features/groups/presentation/pages/details/details_group_user.dart';

/// Punkt wejścia do widoku szczegółów grupy.
/// Na podstawie tego czy bieżący użytkownik jest twórcą grupy
/// renderuje [DetailsGroupAdmin] lub [DetailsGroupUser].
class DetailsGroupPage extends StatelessWidget {
  DetailsGroupPage({super.key, required this.group});
  GroupEntity group;

  @override
  Widget build(BuildContext context) {
    final currentUid = context.read<AuthBloc>().state.user?.uid ?? '';
    final isAdmin = group.authorUID == currentUid;

    if (isAdmin) {
      return DetailsGroupAdmin(group: group);
    } else {
      return DetailsGroupUser(group: group, currentUid: currentUid);
    }
  }
}
