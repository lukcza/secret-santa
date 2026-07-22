import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:secret_santa/core/extensions/context_extension.dart';

class AddGroupPlaceholder extends StatelessWidget {
  const AddGroupPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFD32F2F), // Bright Red
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD32F2F).withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push("/create_group"),
          borderRadius: BorderRadius.circular(30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add_circle_outline_rounded,
                size: 24,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Text(
                'Create / Join Group',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
