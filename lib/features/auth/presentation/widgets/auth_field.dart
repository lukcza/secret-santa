import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (labelText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                labelText,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          TextField(
            controller: controller,
            keyboardType: isEmailField
                ? TextInputType.emailAddress
                : (isPasswordField || isReapetPasswordField)
                    ? TextInputType.visiblePassword
                    : TextInputType.text,
            obscureText: isPasswordField || isReapetPasswordField,
            decoration: InputDecoration(
              prefixIcon: prefixIcon,
              suffixIcon: isPasswordField || isReapetPasswordField ? suffixIcon : null,
              hintText: hintText,
            ),
          ),
        ],
      ),
    );
  }
}