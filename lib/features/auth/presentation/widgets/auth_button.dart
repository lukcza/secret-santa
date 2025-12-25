import 'package:flutter/material.dart';
import 'package:secret_santa/core/extensions/context_extension.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({super.key, required this.onPressed, required this.buttonText});
  final VoidCallback onPressed;
  final String buttonText;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
        ),
        onPressed: () => {
          print("Button pressed"),
          onPressed()
        },
        child: Text(buttonText),
      ),
    );
  }
}
