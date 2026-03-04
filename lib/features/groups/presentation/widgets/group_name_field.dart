
import 'package:flutter/material.dart';
class GroupNameField extends StatefulWidget {
  GroupNameField({super.key, required this.labelText, required this.hintText, required this.controller});

  final String labelText;
  final String hintText;
  final TextEditingController controller;

  @override
  State<GroupNameField> createState() => _GroupNameFieldState();
}

class _GroupNameFieldState extends State<GroupNameField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(widget.labelText),
        ),
        TextField(
          keyboardType: TextInputType.text,
          controller: widget.controller,
          decoration: InputDecoration(
            hintText: widget.hintText,
            suffixIcon: const Icon(Icons.edit),
          )           
        ),
      ],
    );
  }
}