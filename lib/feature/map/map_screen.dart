import 'package:flutter/material.dart';
import 'package:mobil_proje/product/constant/colors.dart';
import 'package:mobil_proje/product/enum/notification_type.dart';
import 'package:mobil_proje/product/enum/notification_status.dart';
import 'package:mobil_proje/product/model/notification_model.dart';
import 'package:mobil_proje/product/mixin/navigation_mixin.dart';
import 'package:mobil_proje/feature/notification/notification_detail_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
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
    ),
  ];

  NotificationModel? _selectedNotification;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Harita',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          // Harita placeholder - gerçek uygulamada google_maps_flutter kullanılacak
          Container(
            color: ColorName.inputBackground,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 64, color: ColorName.loginGreyTextColor),
                  const SizedBox(height: 16),
                  Text(
                    'Harita görünümü',
                    style: TextStyle(color: ColorName.loginGreyTextColor, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'google_maps_flutter paketi eklendiğinde\nharita burada görüntülenecek',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: ColorName.loginGreyTextColor, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          // Pin'ler için overlay
          ..._notifications.map((notification) {
            return Positioned(
              left: 50 + (notification.longitude - 41.2679) * 1000,
              top: 100 + (notification.latitude - 39.9042) * 1000,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedNotification = notification;
                  });
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: notification.type.color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(notification.type.icon, color: Colors.white, size: 20),
                ),
              ),
            );
          }),
          // Seçili bildirim kartı
          if (_selectedNotification != null)
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: _PinInfoCard(
                notification: _selectedNotification!,
                onDetailTap: () {
                  context.navigateTo(NotificationDetailScreen(notification: _selectedNotification!));
                },
                onClose: () {
                  setState(() {
                    _selectedNotification = null;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _PinInfoCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onDetailTap;
  final VoidCallback onClose;

  const _PinInfoCard({
    required this.notification,
    required this.onDetailTap,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorName.inputBackground,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: notification.type.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(notification.type.icon, color: notification.type.color, size: 18),
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
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 20),
                  onPressed: onClose,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 12, color: ColorName.loginGreyTextColor),
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
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onDetailTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorName.goldenAccent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Detayı Gör', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

