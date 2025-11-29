import 'package:flutter/material.dart';

enum NotificationStatus {
  open('Açık', _openColor),
  inProgress('İnceleniyor', _inProgressColor),
  resolved('Çözüldü', _resolvedColor);

  final String label;
  final Color color;

  const NotificationStatus(this.label, this.color);

  static const _openColor = Color(0xFFE53935);
  static const _inProgressColor = Color(0xFFFFD700);
  static const _resolvedColor = Color(0xFF4CAF50);
}
