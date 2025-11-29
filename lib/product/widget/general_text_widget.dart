import 'package:flutter/material.dart';

class GeneralTextWidget extends StatelessWidget {
  final String text;
  final Color color;
  final double size;

  const GeneralTextWidget({
    super.key,
    required this.text,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: size),
    );
  }
}
