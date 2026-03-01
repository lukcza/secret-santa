
import 'package:flutter/material.dart';
class GroupNameField extends StatelessWidget {
  GroupNameField({super.key, required this.labelText, required this.hintText, required this.controller});

  final String labelText;
  final String hintText;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(labelText),
        ),
        TextField(
          keyboardType: TextInputType.text,
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: const Icon(Icons.edit),
          )           
        ),
      ],
    );
  }
}