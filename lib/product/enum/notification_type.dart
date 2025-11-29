import 'package:flutter/material.dart';

enum NotificationType {
  health('Sağlık', Icons.medical_services, _healthColor),
  security('Güvenlik', Icons.security, _securityColor),
  environment('Çevre', Icons.eco, _environmentColor),
  lostFound('Kayıp-Buluntu', Icons.search, _lostFoundColor),
  technical('Teknik Arıza', Icons.build, _technicalColor);

  final String label;
  final IconData icon;
  final Color color;

  const NotificationType(this.label, this.icon, this.color);

  static const _healthColor = Color(0xFFE53935);
  static const _securityColor = Color(0xFFFFD700);
  static const _environmentColor = Color(0xFF4CAF50);
  static const _lostFoundColor = Color(0xFF2196F3);
  static const _technicalColor = Color(0xFFFF9800);
}
