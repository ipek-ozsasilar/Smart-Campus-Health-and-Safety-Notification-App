import 'package:flutter/material.dart';

class TextAndSignUpLogInRowWidget extends StatelessWidget {
  final String firstText;
  final String secondText;
  final VoidCallback? onPressed;
  final WrapAlignment wrapAlignment;

  const TextAndSignUpLogInRowWidget({
    super.key,
    required this.firstText,
    required this.secondText,
    this.onPressed,
    this.wrapAlignment = WrapAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: wrapAlignment,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          firstText,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            secondText,
            style: const TextStyle(
              color: Color(0xFFFFD700), // Golden yellow
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
