import 'package:cloud_firestore/cloud_firestore.dart';
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

  factory NotificationModel.fromMap(Map<String, dynamic> map, String id) {
    return NotificationModel(
      id: id,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      type: NotificationType.values.firstWhere(
        (t) =>
            t.name ==
            (map['type'] as String? ?? NotificationType.security.name),
        orElse: () => NotificationType.security,
      ),
      status: NotificationStatus.values.firstWhere(
        (s) =>
            s.name ==
            (map['status'] as String? ?? NotificationStatus.open.name),
        orElse: () => NotificationStatus.open,
      ),
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : (map['createdAt'] is DateTime
                ? map['createdAt'] as DateTime
                : DateTime.now()),
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0,
      userId: map['userId'] as String? ?? '',
      userName: map['userName'] as String?,
      unit: map['unit'] as String?,
      imageUrls: (map['imageUrls'] as List<dynamic>?)?.cast<String>(),
      followingUserIds: (map['followingUserIds'] as List<dynamic>?)
          ?.cast<String>(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'type': type.name,
      'status': status.name,
      'createdAt': createdAt,
      'latitude': latitude,
      'longitude': longitude,
      'userId': userId,
      if (userName != null) 'userName': userName,
      if (unit != null) 'unit': unit,
      if (imageUrls != null) 'imageUrls': imageUrls,
      if (followingUserIds != null) 'followingUserIds': followingUserIds,
    };
  }

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
