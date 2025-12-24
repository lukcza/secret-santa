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
    return Container(child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(labelText),
        TextField(
          controller: controller,
          keyboardType: isEmailField
              ? TextInputType.emailAddress
              : (isPasswordField || isReapetPasswordField)
                  ? TextInputType.visiblePassword
                  : TextInputType.text,
          obscureText: isPasswordField || isReapetPasswordField ? true : false,
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            hintText: hintText,
          ),
        ),
      ],
    ),);
  }
}