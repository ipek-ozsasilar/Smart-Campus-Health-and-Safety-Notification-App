import 'package:flutter/material.dart';
import 'package:mobil_proje/product/constant/colors.dart';
import 'package:mobil_proje/product/enum/notification_type.dart';
import 'package:mobil_proje/product/enum/notification_status.dart';
import 'package:mobil_proje/product/model/notification_model.dart';
import 'package:mobil_proje/product/mixin/navigation_mixin.dart';
import 'package:mobil_proje/feature/notification/notification_detail_screen.dart';
import 'package:mobil_proje/feature/notification/create_notification_screen.dart';
import 'package:mobil_proje/feature/map/map_screen.dart';
import 'package:mobil_proje/feature/profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _searchQuery = '';
  NotificationType? _selectedFilter;
  bool _showOpenOnly = false;
  bool _showFollowingOnly = false;

  // Mock data - gerçek uygulamada provider'dan gelecek
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

  List<NotificationModel> get _filteredNotifications {
    var filtered = _notifications;

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((notification) {
        return notification.title.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            notification.description.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            );
      }).toList();
    }

    if (_selectedFilter != null) {
      filtered = filtered.where((n) => n.type == _selectedFilter).toList();
    }

    if (_showOpenOnly) {
      filtered = filtered
          .where((n) => n.status == NotificationStatus.open)
          .toList();
    }

    if (_showFollowingOnly) {
      // Mock: takip edilen bildirimler
      filtered = filtered.where((n) => n.id == '1').toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          _currentIndex == 0
              ? 'Bildirimler'
              : _currentIndex == 1
              ? 'Harita'
              : 'Profil',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: _currentIndex == 0
            ? [
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: ColorName.inputBackground,
                        title: const Text(
                          'Ara',
                          style: TextStyle(color: Colors.white),
                        ),
                        content: TextField(
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Başlık veya açıklama ara...',
                            hintStyle: const TextStyle(
                              color: ColorName.loginGreyTextColor,
                            ),
                            filled: true,
                            fillColor: ColorName.darkBackground,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: ColorName.inputBorder,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'Kapat',
                              style: TextStyle(color: ColorName.goldenAccent),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.white),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: ColorName.inputBackground,
                      builder: (context) => Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Filtrele',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Tür:',
                              style: TextStyle(color: Colors.white),
                            ),
                            Wrap(
                              spacing: 8,
                              children: [
                                ...NotificationType.values.map((type) {
                                  return FilterChip(
                                    label: Text(type.label),
                                    selected: _selectedFilter == type,
                                    onSelected: (selected) {
                                      setState(() {
                                        _selectedFilter = selected
                                            ? type
                                            : null;
                                      });
                                      Navigator.pop(context);
                                    },
                                    selectedColor: ColorName.goldenAccent,
                                    labelStyle: TextStyle(
                                      color: _selectedFilter == type
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  );
                                }),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SwitchListTile(
                              title: const Text(
                                'Sadece Açık Olanlar',
                                style: TextStyle(color: Colors.white),
                              ),
                              value: _showOpenOnly,
                              onChanged: (value) {
                                setState(() {
                                  _showOpenOnly = value;
                                });
                                Navigator.pop(context);
                              },
                              activeColor: ColorName.goldenAccent,
                            ),
                            SwitchListTile(
                              title: const Text(
                                'Takip Edilenler',
                                style: TextStyle(color: Colors.white),
                              ),
                              value: _showFollowingOnly,
                              onChanged: (value) {
                                setState(() {
                                  _showFollowingOnly = value;
                                });
                                Navigator.pop(context);
                              },
                              activeColor: ColorName.goldenAccent,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ]
            : null,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // Ana Sayfa
          _filteredNotifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_none,
                        size: 64,
                        color: ColorName.loginGreyTextColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Bildirim bulunamadı',
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
                  itemCount: _filteredNotifications.length,
                  itemBuilder: (context, index) {
                    final notification = _filteredNotifications[index];
                    return _NotificationCard(
                      notification: notification,
                      onTap: () {
                        context.navigateTo(
                          NotificationDetailScreen(notification: notification),
                        );
                      },
                    );
                  },
                ),
          // Harita
          const MapScreen(),
          // Profil
          const ProfileScreen(),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                context.navigateTo(const CreateNotificationScreen());
              },
              backgroundColor: ColorName.goldenAccent,
              child: const Icon(Icons.add, color: Colors.black),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: ColorName.inputBackground,
        selectedItemColor: ColorName.goldenAccent,
        unselectedItemColor: ColorName.loginGreyTextColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Ana Sayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Harita'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _NotificationCard({required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: ColorName.inputBackground,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
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
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
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
                    const SizedBox(height: 4),
                    Text(
                      notification.description,
                      style: TextStyle(
                        color: ColorName.loginGreyTextColor,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
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
                        if (notification.userName != null) ...[
                          const SizedBox(width: 16),
                          Icon(
                            Icons.person,
                            size: 14,
                            color: ColorName.loginGreyTextColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            notification.userName!,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
