import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobil_proje/product/constant/colors.dart';
import 'package:mobil_proje/product/model/notification_model.dart';
import 'package:mobil_proje/product/model/user_model.dart';
import 'package:mobil_proje/product/mixin/navigation_mixin.dart';
import 'package:mobil_proje/feature/notification/notification_detail_screen.dart';
import 'package:mobil_proje/feature/admin/emergency_alert_screen.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

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
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: ColorName.goldenAccent),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Bildirimler yüklenirken hata oluştu',
                style: TextStyle(color: ColorName.loginGreyTextColor),
              ),
            );
          }

          final notifications =
              snapshot.data?.docs
                  .map((doc) => NotificationModel.fromMap(doc.data(), doc.id))
                  .toList() ??
              [];

          if (notifications.isEmpty) {
            return Center(
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
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                color: ColorName.inputBackground,
                child: ListTile(
                  onTap: () {
                    context.navigateTo(
                      NotificationDetailScreen(
                        notification: notification,
                        currentUserRole: UserRole.admin,
                      ),
                    );
                  },
                  leading: Container(
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
                  title: Text(
                    notification.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        notification.description,
                        style: TextStyle(
                          color: ColorName.loginGreyTextColor,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 12,
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
                          if (notification.unit != null) ...[
                            const SizedBox(width: 12),
                            Icon(
                              Icons.business,
                              size: 12,
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
                        ],
                      ),
                    ],
                  ),
                  trailing: Container(
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
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
