import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:secret_santa/core/extensions/context_extension.dart';
import 'package:secret_santa/core/l10n/app_localizations.dart';
import 'package:secret_santa/core/theme/app_theme.dart';

class InviteCard extends StatefulWidget {
  const InviteCard({super.key, required this.inviteCode});

  final String inviteCode;

  @override
  State<InviteCard> createState() => _InviteCardState();
}

class _InviteCardState extends State<InviteCard> {
  bool _codeCopied = false;
  bool _linkCopied = false;
  String get _link => 'https://secretsanta.app/join/${widget.inviteCode}';
  Future<void> _copyCode() async {
    await Clipboard.setData(ClipboardData(text: widget.inviteCode));
    setState(() => _codeCopied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _codeCopied = false);
  }
  Future<void> _copyLink() async {
    await Clipboard.setData(ClipboardData(text: _link));
    setState(() => _linkCopied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _linkCopied = false);
  }
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primary.withValues(alpha: 0.13),
            AppTheme.primary.withValues(alpha: 0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primary.withValues(alpha: 0.22),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.tag_rounded,
                  size: 16,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.loc.inviteCodeLabel.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: colorScheme.onSurface.withValues(alpha: 0.45),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: widget.inviteCode.split('').map((char) {
                        return Container(
                          margin: const EdgeInsets.only(right: 4),
                          width: 22,
                          height: 28,
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppTheme.primary.withValues(alpha: 0.3),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            char,
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _CopyButton(
                label: _codeCopied ? '✓' : context.loc.copy.toUpperCase(),
                copied: _codeCopied,
                onTap: _copyCode,
                color: colorScheme.primary,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(
            height: 1,
            color: AppTheme.primary.withValues(alpha: 0.12),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.link_rounded,
                  size: 16,
                  color: colorScheme.secondary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _link,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              _CopyButton(
                label: _linkCopied ? '✓' : context.loc.copy.toUpperCase(),
                copied: _linkCopied,
                onTap: _copyLink,
                color: colorScheme.secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CopyButton extends StatelessWidget {
  const _CopyButton({
    required this.label,
    required this.copied,
    required this.onTap,
    required this.color,
  });

  final String label;
  final bool copied;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: GestureDetector(
        key: ValueKey(copied),
        onTap: copied ? null : onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: copied ? AppTheme.forest.withValues(alpha: 0.15) : color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: copied ? AppTheme.forest.withValues(alpha: 0.4) : color.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: copied ? AppTheme.forest : color,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
