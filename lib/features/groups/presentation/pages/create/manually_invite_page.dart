import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:secret_santa/core/theme/app_theme.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_event.dart';
import 'package:secret_santa/core/extensions/context_extension.dart';
import 'package:secret_santa/core/utils/validators.dart';

class ManuallyInvitePage extends StatefulWidget {
  final void Function(List<String> email)? onBack;
  const ManuallyInvitePage({super.key, this.onBack});
  @override
  State<ManuallyInvitePage> createState() => _ManuallyInvitePageState();
}

class _ManuallyInvitePageState extends State<ManuallyInvitePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();

  bool _codeCopied = false;
  bool _linkCopied = false;
  bool _emailSent = false;
  String? _emailError;

  final List<String> _pendingInvites = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<GroupBloc>().state.inviteCode == null) {
        context.read<GroupBloc>().add(const GenerateInviteCodeEvent());
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  void _copyCode() async {
    final code = context.read<GroupBloc>().state.inviteCode ?? '';
    await Clipboard.setData(ClipboardData(text: code));
    setState(() => _codeCopied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _codeCopied = false);
  }

  void _copyLink() async {
    final code = context.read<GroupBloc>().state.inviteCode ?? '';
    final link = 'https://secretsanta.app/join/$code';
    await Clipboard.setData(ClipboardData(text: link));
    setState(() => _linkCopied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _linkCopied = false);
  }

  void _sendEmailInvite() async {
    final email = _emailController.text.trim();
    final validationError = Validators.validateEmail(
      email,
      emptyMessage: context.loc.errorEnterEmail,
      invalidMessage: context.loc.emailInvalid,
    );
    if (validationError != null) {
      setState(() => _emailError = validationError);
      return;
    }
    if (_pendingInvites.contains(email)) {
      setState(() => _emailError = context.loc.errorAlreadySentEmail);
      return;
    }

    setState(() {
      _emailError = null;
      _emailSent = true;
      _pendingInvites.add(email);
    });
    _emailController.clear();
    _emailFocusNode.unfocus();

    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _emailSent = false);
  }

  void _removePendingInvite(String email) {
    setState(() => _pendingInvites.remove(email));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          widget.onBack?.call(List.unmodifiable(_pendingInvites));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            context.loc.addFriendsAppBarTitle,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.loc.inviteToYourGroup,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.loc.chooseInviteMethod,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Custom Tab Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildTabBar(),
              ),
              const SizedBox(height: 24),

              // Tab content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildCodeTab(),
                    _buildLinkTab(),
                    _buildEmailTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color:
            Theme.of(context).brightness == Brightness.dark
                ? AppTheme.backgroundDark.withValues(alpha: 0.5)
                : colorScheme.onSurface.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(11),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.35),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.all(3),
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: colorScheme.onSurface.withValues(alpha: 0.55),
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.tag_rounded, size: 16),
                const SizedBox(width: 6),
                Text(context.loc.codeTab),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.link_rounded, size: 16),
                const SizedBox(width: 6),
                Text(context.loc.linkTab),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.email_outlined, size: 16),
                const SizedBox(width: 6),
                Text(context.loc.emailTab),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeTab() {
    final colorScheme = Theme.of(context).colorScheme;
    final code = context.watch<GroupBloc>().state.inviteCode ?? '------';
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primary.withValues(alpha: 0.15),
                  AppTheme.primary.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppTheme.primary.withValues(alpha: 0.25),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.tag_rounded,
                    size: 32,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  context.loc.groupCodeLabel,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.55),
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      code.split('').map((char) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 28,
                          height: 38,
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppTheme.primary.withValues(alpha: 0.3),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            char,
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0,
                            ),
                          ),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child:
                        _codeCopied
                            ? _successButton(context.loc.codeCopied)
                            : ElevatedButton.icon(
                              key: const ValueKey('copy_code_btn'),
                              onPressed: _copyCode,
                              icon: const Icon(Icons.copy_rounded, size: 18),
                              label: Text(context.loc.copyCode),
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                padding: const EdgeInsets.all(16),
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildInfoBanner(
            icon: Icons.info_outline_rounded,
            text: context.loc.codeInfoBanner,
            colorScheme: colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildLinkTab() {
    final colorScheme = Theme.of(context).colorScheme;
    final code = context.watch<GroupBloc>().state.inviteCode ?? '';
    final link = 'https://secretsanta.app/join/$code';
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.secondary.withValues(alpha: 0.13),
                  colorScheme.secondary.withValues(alpha: 0.04),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: colorScheme.secondary.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colorScheme.secondary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.link_rounded,
                    size: 32,
                    color: colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  context.loc.inviteLinkLabel,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.55),
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: colorScheme.secondary.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.link_rounded,
                        size: 18,
                        color: colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          link,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: colorScheme.onSurface.withValues(
                              alpha: 0.75,
                            ),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child:
                            _linkCopied
                                ? _successButton(
                                  context.loc.copied,
                                  small: true,
                                )
                                : OutlinedButton.icon(
                                  key: const ValueKey('copy_link_btn'),
                                  onPressed: _copyLink,
                                  icon: const Icon(
                                    Icons.copy_rounded,
                                    size: 16,
                                  ),
                                  label: Text(context.loc.copy),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: colorScheme.secondary,
                                    side: BorderSide(
                                      color: colorScheme.secondary.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                    shape: const StadiumBorder(),
                                    padding: const EdgeInsets.all(12),
                                  ),
                                ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.share_rounded, size: 16),
                        label: Text(context.loc.share),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.secondary,
                          foregroundColor: Colors.white,
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildInfoBanner(
            icon: Icons.info_outline_rounded,
            text: context.loc.linkInfoBanner,
            colorScheme: colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildEmailTab() {
    final colorScheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: colorScheme.onSurface.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.loc.emailAddressLabel,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendEmailInvite(),
                        onChanged: (_) {
                          if (_emailError != null) {
                            setState(() => _emailError = null);
                          }
                        },
                        style: const TextStyle(fontSize: 15),
                        decoration: InputDecoration(
                          hintText: context.loc.emailAddressHint,
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color:
                                _emailError != null
                                    ? colorScheme.error
                                    : colorScheme.onSurface.withValues(
                                      alpha: 0.4,
                                    ),
                          ),
                          errorText: _emailError,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color:
                                  _emailError != null
                                      ? colorScheme.error
                                      : colorScheme.onSurface.withValues(
                                        alpha: 0.15,
                                      ),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: colorScheme.primary,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: colorScheme.error,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: colorScheme.error,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          filled: true,
                          fillColor:
                              Theme.of(context).brightness == Brightness.dark
                                  ? AppTheme.backgroundDark.withValues(
                                    alpha: 0.5,
                                  )
                                  : colorScheme.onSurface.withValues(
                                    alpha: 0.03,
                                  ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child:
                              _emailSent
                                  ? _successButton(context.loc.inviteSent)
                                  : ElevatedButton.icon(
                                    key: const ValueKey('send_invite_btn'),
                                    onPressed: _sendEmailInvite,
                                    icon: const Icon(
                                      Icons.send_rounded,
                                      size: 18,
                                    ),
                                    label: Text(context.loc.sendInvite),
                                    style: ElevatedButton.styleFrom(
                                      shape: const StadiumBorder(),
                                      padding: const EdgeInsets.all(12),
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (_pendingInvites.isNotEmpty) ...[
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    context.loc.pendingInvites,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_pendingInvites.length}',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _pendingInvites.length,
              itemBuilder: (context, index) {
                final email = _pendingInvites[index];
                return _buildPendingInviteTile(email);
              },
            ),
          ] else ...[
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildInfoBanner(
                icon: Icons.mail_outline_rounded,
                text: context.loc.emailInfoBanner,
                colorScheme: colorScheme,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPendingInviteTile(String email) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              email[0].toUpperCase(),
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  email,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 11,
                      color: colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      context.loc.invitePending,
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.45),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.close_rounded,
              size: 18,
              color: colorScheme.onSurface.withValues(alpha: 0.4),
            ),
            onPressed: () => _removePendingInvite(email),
            tooltip: context.loc.removeInviteTooltip,
          ),
        ],
      ),
    );
  }

  Widget _successButton(String label, {bool small = false}) {
    return ElevatedButton.icon(
      key: ValueKey('success_$label'),
      onPressed: null,
      icon: Icon(Icons.check_circle_rounded, size: small ? 16 : 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.forest,
        foregroundColor: Colors.white,
        disabledBackgroundColor: AppTheme.forest,
        disabledForegroundColor: Colors.white,
        shape: const StadiumBorder(),
        padding: EdgeInsets.all(small ? 12 : 14),
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: small ? 13 : 14,
        ),
      ),
    );
  }

  Widget _buildInfoBanner({
    required IconData icon,
    required String text,
    required ColorScheme colorScheme,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.55),
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
