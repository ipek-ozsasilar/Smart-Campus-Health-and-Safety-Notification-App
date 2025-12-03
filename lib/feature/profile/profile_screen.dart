import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobil_proje/product/constant/colors.dart';
import 'package:mobil_proje/product/model/user_model.dart';
import 'package:mobil_proje/product/model/notification_model.dart';
import 'package:mobil_proje/product/mixin/navigation_mixin.dart';
import 'package:mobil_proje/feature/notification/notification_detail_screen.dart';
import 'package:mobil_proje/feature/login/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Kullanıcı oturumu bulunamadı',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final userDocStream = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .snapshots();

    final followedNotificationsStream = FirebaseFirestore.instance
        .collection('notifications')
        .where('followingUserIds', arrayContains: currentUser.uid)
        .snapshots();

    return Scaffold(
      backgroundColor: ColorName.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Profil',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: userDocStream,
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: ColorName.goldenAccent),
            );
          }

          if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
            return Center(
              child: Text(
                'Kullanıcı bilgisi bulunamadı',
                style: TextStyle(color: ColorName.loginGreyTextColor),
              ),
            );
          }

          final userModel = UserModel.fromMap(
            userSnapshot.data!.data()!,
            userSnapshot.data!.id,
          );

          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: followedNotificationsStream,
            builder: (context, notifSnapshot) {
              final followedNotifications =
                  notifSnapshot.data?.docs
                      .map(
                        (doc) => NotificationModel.fromMap(doc.data(), doc.id),
                      )
                      .toList() ??
                  [];

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Info Card
                    Card(
                      color: ColorName.inputBackground,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: ColorName.goldenAccent,
                              child: Text(
                                userModel.fullName.isNotEmpty
                                    ? userModel.fullName[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              userModel.fullName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              userModel.email,
                              style: TextStyle(
                                color: ColorName.loginGreyTextColor,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: ColorName.goldenAccent.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                userModel.role.label,
                                style: const TextStyle(
                                  color: ColorName.goldenAccent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (userModel.unit != null) ...[
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.business,
                                    size: 16,
                                    color: ColorName.loginGreyTextColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    userModel.unit!,
                                    style: TextStyle(
                                      color: ColorName.loginGreyTextColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Notification Settings
                    const Text(
                      'Bildirim Ayarları',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      color: ColorName.inputBackground,
                      child: Column(
                        children: [
                          SwitchListTile(
                            title: const Text(
                              'Bildirimler',
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: const Text(
                              'Tüm bildirimleri aç/kapat',
                              style: TextStyle(
                                color: ColorName.loginGreyTextColor,
                              ),
                            ),
                            value: _notificationsEnabled,
                            onChanged: (value) {
                              setState(() {
                                _notificationsEnabled = value;
                              });
                            },
                            activeColor: ColorName.goldenAccent,
                          ),
                          SwitchListTile(
                            title: const Text(
                              'E-posta Bildirimleri',
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: const Text(
                              'E-posta ile bildirim al',
                              style: TextStyle(
                                color: ColorName.loginGreyTextColor,
                              ),
                            ),
                            value: _emailNotifications && _notificationsEnabled,
                            onChanged: _notificationsEnabled
                                ? (value) {
                                    setState(() {
                                      _emailNotifications = value;
                                    });
                                  }
                                : null,
                            activeColor: ColorName.goldenAccent,
                          ),
                          SwitchListTile(
                            title: const Text(
                              'Push Bildirimleri',
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: const Text(
                              'Anlık bildirim al',
                              style: TextStyle(
                                color: ColorName.loginGreyTextColor,
                              ),
                            ),
                            value: _pushNotifications && _notificationsEnabled,
                            onChanged: _notificationsEnabled
                                ? (value) {
                                    setState(() {
                                      _pushNotifications = value;
                                    });
                                  }
                                : null,
                            activeColor: ColorName.goldenAccent,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Followed Notifications
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Takip Edilen Bildirimler',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${followedNotifications.length}',
                          style: TextStyle(
                            color: ColorName.goldenAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (followedNotifications.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: ColorName.inputBackground,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Takip edilen bildirim yok',
                            style: TextStyle(
                              color: ColorName.loginGreyTextColor,
                            ),
                          ),
                        ),
                      )
                    else
                      ...followedNotifications.map((notification) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          color: ColorName.inputBackground,
                          child: ListTile(
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
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              notification.timeAgo,
                              style: TextStyle(
                                color: ColorName.loginGreyTextColor,
                                fontSize: 12,
                              ),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: notification.status.color.withOpacity(
                                  0.2,
                                ),
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
                            onTap: () {
                              context.navigateTo(
                                NotificationDetailScreen(
                                  notification: notification,
                                ),
                              );
                            },
                          ),
                        );
                      }),
                    const SizedBox(height: 24),
                    // Logout Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: ColorName.inputBackground,
                              title: const Text(
                                'Çıkış Yap',
                                style: TextStyle(color: Colors.white),
                              ),
                              content: const Text(
                                'Çıkış yapmak istediğinize emin misiniz?',
                                style: TextStyle(
                                  color: ColorName.loginGreyTextColor,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    'İptal',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LogInView(),
                                      ),
                                      (route) => false,
                                    );
                                  },
                                  child: const Text(
                                    'Çıkış Yap',
                                    style: TextStyle(
                                      color: ColorName.goldenAccent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text('Çıkış Yap'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ColorName.errorRed,
                          side: const BorderSide(color: ColorName.errorRed),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}