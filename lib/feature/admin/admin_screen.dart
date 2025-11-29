import 'package:flutter/material.dart';
import 'package:mobil_proje/product/constant/colors.dart';
import 'package:mobil_proje/product/enum/notification_type.dart';
import 'package:mobil_proje/product/enum/notification_status.dart';
import 'package:mobil_proje/product/model/notification_model.dart';
import 'package:mobil_proje/product/model/user_model.dart';
import 'package:mobil_proje/product/mixin/navigation_mixin.dart';
import 'package:mobil_proje/feature/notification/notification_detail_screen.dart';
import 'package:mobil_proje/feature/admin/emergency_alert_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  // Mock data
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: '1',
      title: 'Kampüs içi güvenlik kamerası arızası',
      description: 'E2 binası girişindeki güvenlik kamerası çalışmıyor',
      type: NotificationType.security,
      status: NotificationStatus.open,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      latitude: 39.9042,
      longitude: 41.2679,
      userId: 'user1',
      userName: 'Ahmet Yılmaz',
      unit: 'Bilgisayar Mühendisliği',
    ),
    NotificationModel(
      id: '2',
      title: 'Çöp kutusu taşmış',
      description: 'Kütüphane önündeki çöp kutusu taşmış durumda',
      type: NotificationType.environment,
      status: NotificationStatus.inProgress,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      latitude: 39.9050,
      longitude: 41.2685,
      userId: 'user2',
      userName: 'Mehmet Demir',
      unit: 'Elektrik Mühendisliği',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Admin Paneli',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.warning, color: ColorName.goldenAccent),
            onPressed: () {
              context.navigateTo(const EmergencyAlertScreen());
            },
            tooltip: 'Acil Durum Bildirimi',
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.admin_panel_settings,
                    size: 64,
                    color: ColorName.loginGreyTextColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Henüz bildirim yok',
                    style: TextStyle(
                      color: ColorName.loginGreyTextColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return _AdminNotificationCard(
                  notification: notification,
                  onTap: () {
                    context.navigateTo(
                      NotificationDetailScreen(
                        notification: notification,
                        currentUserRole: UserRole.admin,
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class _AdminNotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _AdminNotificationCard({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: ColorName.inputBackground,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: notification.type.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      notification.type.icon,
                      color: notification.type.color,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.type.label,
                          style: TextStyle(
                            color: notification.type.color,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          notification.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: notification.status.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      notification.status.label,
                      style: TextStyle(
                        color: notification.status.color,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                notification.description,
                style: TextStyle(
                  color: ColorName.loginGreyTextColor,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 14,
                    color: ColorName.loginGreyTextColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    notification.userName ?? 'Bilinmeyen',
                    style: TextStyle(
                      color: ColorName.loginGreyTextColor,
                      fontSize: 12,
                    ),
                  ),
                  if (notification.unit != null) ...[
                    const SizedBox(width: 16),
                    Icon(
                      Icons.business,
                      size: 14,
                      color: ColorName.loginGreyTextColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      notification.unit!,
                      style: TextStyle(
                        color: ColorName.loginGreyTextColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                  const Spacer(),
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: ColorName.loginGreyTextColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    notification.timeAgo,
                    style: TextStyle(
                      color: ColorName.loginGreyTextColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
