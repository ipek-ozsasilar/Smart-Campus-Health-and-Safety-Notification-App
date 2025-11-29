import 'package:flutter/material.dart';

class GlobalTextButton extends StatelessWidget {
  final String text;
  final Color? textColor;
  final VoidCallback? onPressed;

  const GlobalTextButton({
    super.key,
    required this.text,
    this.textColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? const Color(0xFFB0B0B0),
          fontSize: 14,
        ),
      ),
    );
  }
}
