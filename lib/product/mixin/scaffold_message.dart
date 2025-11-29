import 'package:flutter/material.dart';

mixin ScaffoldMessage<T extends StatefulWidget> on State<T> {
  void showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
