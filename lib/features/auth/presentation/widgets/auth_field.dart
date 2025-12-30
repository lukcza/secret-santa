import 'package:flutter/material.dart';

class AuthField extends StatefulWidget {
  AuthField({
    super.key,
    this.labelText = '',
    this.hintText = '',
    required this.controller,
    this.prefixIcon = const Icon(Icons.person),
    this.suffixIcon = const Icon(Icons.lock),
    this.isPasswordField = false,
    this.isEmailField = false,
    this.isReapetPasswordField = false,
  });
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final Icon prefixIcon;
  final Icon suffixIcon;
  final bool isPasswordField;
  final bool isEmailField;
  final bool isReapetPasswordField;
  

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  late bool isObscure =
      widget.isPasswordField || widget.isReapetPasswordField ? true : false;

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
          TextField(
            controller: widget.controller,
            keyboardType:
                widget.isEmailField
                    ? TextInputType.emailAddress
                    : (widget.isPasswordField || widget.isReapetPasswordField)
                    ? TextInputType.visiblePassword
                    : TextInputType.text,
            obscureText: isObscure,
            decoration: InputDecoration(
              prefixIcon: widget.prefixIcon,
              suffixIcon:
                  widget.isPasswordField || widget.isReapetPasswordField
                      ? IconButton(
                        onPressed:
                            () => setState(() {
                              isObscure = !isObscure;
                            }),
                        icon:
                            isObscure
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                      )
                      : null,
              hintText: widget.hintText,
            ),
          ),
        ],
      ),
    );
  }
}