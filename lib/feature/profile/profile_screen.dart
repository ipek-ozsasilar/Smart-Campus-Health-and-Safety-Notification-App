import 'package:flutter/material.dart';
import 'package:mobil_proje/product/constant/colors.dart';
import 'package:mobil_proje/product/model/user_model.dart';
import 'package:mobil_proje/product/model/notification_model.dart';
import 'package:mobil_proje/product/enum/notification_type.dart';
import 'package:mobil_proje/product/enum/notification_status.dart';
import 'package:mobil_proje/product/mixin/navigation_mixin.dart';
import 'package:mobil_proje/feature/notification/notification_detail_screen.dart';
import 'package:mobil_proje/feature/login/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Mock user data
  final UserModel _currentUser = UserModel(
    id: 'user1',
    fullName: 'Ahmet Yılmaz',
    email: 'ahmet@example.com',
    role: UserRole.user,
    unit: 'Bilgisayar Mühendisliği',
  );

  // Mock followed notifications
  final List<NotificationModel> _followedNotifications = [
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
  ];

  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
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
                        _currentUser.fullName[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _currentUser.fullName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _currentUser.email,
                      style: TextStyle(
                        color: ColorName.loginGreyTextColor,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: ColorName.goldenAccent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _currentUser.role.label,
                        style: const TextStyle(
                          color: ColorName.goldenAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (_currentUser.unit != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.business, size: 16, color: ColorName.loginGreyTextColor),
                          const SizedBox(width: 4),
                          Text(
                            _currentUser.unit!,
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
                    title: const Text('Bildirimler', style: TextStyle(color: Colors.white)),
                    subtitle: const Text('Tüm bildirimleri aç/kapat', style: TextStyle(color: ColorName.loginGreyTextColor)),
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                    activeColor: ColorName.goldenAccent,
                  ),
                  SwitchListTile(
                    title: const Text('E-posta Bildirimleri', style: TextStyle(color: Colors.white)),
                    subtitle: const Text('E-posta ile bildirim al', style: TextStyle(color: ColorName.loginGreyTextColor)),
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
                    title: const Text('Push Bildirimleri', style: TextStyle(color: Colors.white)),
                    subtitle: const Text('Anlık bildirim al', style: TextStyle(color: ColorName.loginGreyTextColor)),
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
                  '${_followedNotifications.length}',
                  style: TextStyle(
                    color: ColorName.goldenAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_followedNotifications.isEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: ColorName.inputBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Takip edilen bildirim yok',
                    style: TextStyle(color: ColorName.loginGreyTextColor),
                  ),
                ),
              )
            else
              ..._followedNotifications.map((notification) {
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
                      child: Icon(notification.type.icon, color: notification.type.color),
                    ),
                    title: Text(
                      notification.title,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      notification.timeAgo,
                      style: TextStyle(color: ColorName.loginGreyTextColor, fontSize: 12),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                    onTap: () {
                      context.navigateTo(NotificationDetailScreen(notification: notification));
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
                      title: const Text('Çıkış Yap', style: TextStyle(color: Colors.white)),
                      content: const Text(
                        'Çıkış yapmak istediğinize emin misiniz?',
                        style: TextStyle(color: ColorName.loginGreyTextColor),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('İptal', style: TextStyle(color: Colors.white)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const LogInView()),
                              (route) => false,
                            );
                          },
                          child: const Text('Çıkış Yap', style: TextStyle(color: ColorName.goldenAccent)),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

