import 'package:flutter/material.dart';

class OrContinueWithRow extends StatelessWidget {
  const OrContinueWithRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFF3A3A4E), thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Or continue with',
            style: TextStyle(color: const Color(0xFFB0B0B0), fontSize: 14),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFF3A3A4E), thickness: 1)),
      ],
    );
  }
}
