import 'package:mobil_proje/product/enum/notification_type.dart';
import 'package:mobil_proje/product/enum/notification_status.dart';

class NotificationModel {
  final String id;
  final String title;
  final String description;
  final NotificationType type;
  final NotificationStatus status;
  final DateTime createdAt;
  final double latitude;
  final double longitude;
  final String userId;
  final String? userName;
  final String? unit;
  final List<String>? imageUrls;
  final List<String>? followingUserIds;

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.status,
    required this.createdAt,
    required this.latitude,
    required this.longitude,
    required this.userId,
    this.userName,
    this.unit,
    this.imageUrls,
    this.followingUserIds,
  });

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} gün önce';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} saat önce';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} dakika önce';
    } else {
      return 'Az önce';
    }
  }
}
