import 'package:flutter/material.dart';

class CustomConfirmButton extends StatefulWidget {
  const CustomConfirmButton({
    super.key,
    required this.shimmerAnim,
    required this.confirmed,
    this.onTap,
    required this.confirmedLabel,
    required this.unconfirmedLabel,
  });

  final Animation<double> shimmerAnim;
  final bool confirmed;
  final VoidCallback? onTap;
  final String confirmedLabel;
  final String unconfirmedLabel;

  @override
  State<CustomConfirmButton> createState() => _CustomConfirmButtonState();
}

class _CustomConfirmButtonState extends State<CustomConfirmButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDisabled = widget.onTap == null;
    return GestureDetector(
      onTapDown: isDisabled ? null : (_) => setState(() => _pressed = true),
      onTapUp: isDisabled
          ? null
          : (_) {
              setState(() => _pressed = false);
              widget.onTap?.call();
            },
      onTapCancel: isDisabled ? null : () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          width: double.infinity,
          height: 58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: isDisabled
                ? LinearGradient(
                    colors: [
                      cs.onSurface.withValues(alpha: 0.15),
                      cs.onSurface.withValues(alpha: 0.10),
                    ],
                  )
                : LinearGradient(
                    colors: [
                      cs.primary,
                      Color.lerp(cs.primary, cs.tertiary, 0.45)!,
                      cs.primary.withValues(alpha: 0.85),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            boxShadow: isDisabled
                ? []
                : [
                    BoxShadow(
                      color: cs.primary.withValues(alpha: 0.40),
                      blurRadius: 16,
                      offset: const Offset(0, 5),
                    ),
                  ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (!isDisabled)
                  AnimatedBuilder(
                    animation: widget.shimmerAnim,
                    builder: (_, __) => Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(
                            widget.shimmerAnim.value - 0.4,
                            -1,
                          ),
                          end: Alignment(widget.shimmerAnim.value + 0.4, 1),
                          colors: [
                            Colors.transparent,
                            Colors.white.withValues(alpha: 0.10),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.confirmed
                          ? Icons.check_circle_rounded
                          : Icons.check_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.confirmed
                          ? widget.confirmedLabel
                          : widget.unconfirmedLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
