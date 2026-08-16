import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:secret_santa/core/extensions/context_extension.dart';
import 'package:secret_santa/core/theme/app_theme.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_bloc.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_event.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_state.dart';
import 'package:secret_santa/features/groups/presentation/widgets/group_found_modal.dart';

class JoinGroupPage extends StatefulWidget {
  final String? initialInviteCode;

  const JoinGroupPage({
    super.key,
    this.initialInviteCode,
  });

  @override
  State<JoinGroupPage> createState() => _JoinGroupPageState();
}

class _JoinGroupPageState extends State<JoinGroupPage> {
  late final TextEditingController _codeController;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.initialInviteCode ?? '');
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _onJoinPressed() {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.loc.invalidGroupCode)),
      );
      return;
    }
    context.read<GroupBloc>().add(FetchGroupByInviteCodeEvent(groupCode: code));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return BlocListener<GroupBloc, GroupState>(
      listener: (context, state) {
        if (state.joinStatus == JoinGroupStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? context.loc.unknownError),
              backgroundColor: cs.error,
            ),
          );
        }
        if (state.joinStatus == JoinGroupStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.loc.joinGroupSuccess)),
          );
          if (state.group != null) {
            context.go('/group/${state.group!.id}');
          } else {
            context.go('/');
          }
        }
        if (state.joinStatus == JoinGroupStatus.found && state.group != null) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            backgroundColor: Colors.transparent,
            builder: (_) => BlocProvider.value(
              value: context.read<GroupBloc>(),
              child: GroupFoundModal(
                group: state.group!,
                onJoinPressed: () {
                  Navigator.of(context).pop();
                  context.read<GroupBloc>().add(
                        JoinGroupByInviteCodeEvent(
                          groupCode: _codeController.text.trim(),
                        ),
                      );
                },
              ),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text(
            context.loc.joinGroupTitle,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),

                      // ── Header ──────────────────────────────────────────
                      Text(
                        context.loc.joinExistingGroup,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        context.loc.joinExistingGroupDescription,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: cs.onSurface.withValues(alpha: 0.55),
                            ),
                      ),
                      const SizedBox(height: 24),

                      // ── Code Input ──────────────────────────────────────
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0, bottom: 8.0, top: 8.0),
                            child: Text(
                              context.loc.groupCodeLabel,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          TextField(
                            controller: _codeController,
                            textCapitalization: TextCapitalization.characters,
                            style: const TextStyle(
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            decoration: InputDecoration(
                              hintText: 'SANTA2026',
                              suffixIcon: _codeController.text.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () => setState(() => _codeController.clear()),
                                      child: const Icon(Icons.clear, size: 18),
                                    )
                                  : const Icon(Icons.vpn_key_rounded, size: 18),
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // ── Bottom Button ─────────────────────────────────────────────
              BlocBuilder<GroupBloc, GroupState>(
                builder: (context, state) {
                  final isLoading = state.joinStatus == JoinGroupStatus.loading;

                  return Container(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: isLoading ? null : _onJoinPressed,
                        icon: isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.arrow_forward_rounded),
                        label: Text(context.loc.joinGroupButton),
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
