import 'package:flutter/material.dart';

class AuthFormField extends StatefulWidget {
  const AuthFormField({
    super.key,
    this.labelText = '',
    this.hintText = '',
    required this.controller,
    this.prefixIcon,
    this.isPasswordField = false,
    this.isEmailField = false,
    this.isRepeatPasswordField = false,
    this.validator,
    this.originalPasswordController,
  });

  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final Icon? prefixIcon;
  final bool isPasswordField;
  final bool isEmailField;
  final bool isRepeatPasswordField;
  final String? Function(String?)? validator;
  final TextEditingController? originalPasswordController;

  @override
  State<AuthFormField> createState() => _AuthFormFieldState();
}

class _AuthFormFieldState extends State<AuthFormField> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.isPasswordField || widget.isRepeatPasswordField;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.labelText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                widget.labelText,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          TextFormField(
            controller: widget.controller,
            keyboardType: _getKeyboardType(),
            obscureText: _isObscure,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: widget.validator,
            decoration: InputDecoration(
              prefixIcon: widget.prefixIcon,
              suffixIcon: _buildSuffixIcon(),
              hintText: widget.hintText,
            ),
          ),
        ],
      ),
    );
  }

  TextInputType _getKeyboardType() {
    if (widget.isEmailField) {
      return TextInputType.emailAddress;
    } else if (widget.isPasswordField || widget.isRepeatPasswordField) {
      return TextInputType.visiblePassword;
    }
    return TextInputType.text;
  }

  Widget? _buildSuffixIcon() {
    if (widget.isPasswordField || widget.isRepeatPasswordField) {
      return IconButton(
        onPressed: () => setState(() => _isObscure = !_isObscure),
        icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
      );
    }
    return null;
  }
}
