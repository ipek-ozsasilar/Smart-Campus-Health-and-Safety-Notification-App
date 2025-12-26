import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobil_proje/product/constant/colors.dart';
import 'package:mobil_proje/product/enum/notification_status.dart';
import 'package:mobil_proje/product/enum/notification_type.dart';
import 'package:mobil_proje/product/model/notification_model.dart';
import 'package:mobil_proje/product/model/user_model.dart';

class NotificationDetailScreen extends StatefulWidget {
  final NotificationModel notification;
  final UserRole? currentUserRole;

  const NotificationDetailScreen({
    super.key,
    required this.notification,
    this.currentUserRole = UserRole.user,
  });

  @override
  State<NotificationDetailScreen> createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
  bool _isFollowing = false;
  NotificationStatus _currentStatus = NotificationStatus.open;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _currentUserId = FirebaseAuth.instance.currentUser?.uid;
    _currentStatus = widget.notification.status;
    if (_currentUserId != null) {
      _isFollowing =
          widget.notification.followingUserIds?.contains(_currentUserId) ??
          false;
    }
  }

  double _getMarkerHue(NotificationType type) {
    switch (type) {
      case NotificationType.security:
        return BitmapDescriptor.hueYellow;
      case NotificationType.health:
        return BitmapDescriptor.hueRed;
      case NotificationType.environment:
        return BitmapDescriptor.hueGreen;
      case NotificationType.lostFound:
        return BitmapDescriptor.hueBlue;
      case NotificationType.technical:
        return BitmapDescriptor.hueOrange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Bildirim Detayı',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _currentStatus.color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _currentStatus.label,
                style: TextStyle(
                  color: _currentStatus.color,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Type and Title
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: widget.notification.type.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    widget.notification.type.icon,
                    color: widget.notification.type.color,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.notification.type.label,
                        style: TextStyle(
                          color: widget.notification.type.color,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.notification.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Description
            const Text(
              'Açıklama',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorName.inputBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.notification.description,
                style: TextStyle(
                  color: ColorName.loginGreyTextColor,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Location
            const Text(
              'Konum',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: ColorName.inputBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: ColorName.inputBorder, width: 1),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        widget.notification.latitude,
                        widget.notification.longitude,
                      ),
                      zoom: 16.0,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId(widget.notification.id),
                        position: LatLng(
                          widget.notification.latitude,
                          widget.notification.longitude,
                        ),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          _getMarkerHue(widget.notification.type),
                        ),
                        infoWindow: InfoWindow(
                          title: widget.notification.title,
                          snippet: widget.notification.type.label,
                        ),
                      ),
                    },
                    mapType: MapType.normal,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    compassEnabled: false,
                    mapToolbarEnabled: false,
                    rotateGesturesEnabled: false,
                    scrollGesturesEnabled: true,
                    tiltGesturesEnabled: false,
                    zoomGesturesEnabled: true,
                    onMapCreated: (_) {},
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: ColorName.goldenAccent,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${widget.notification.latitude.toStringAsFixed(4)}, ${widget.notification.longitude.toStringAsFixed(4)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Images
            if (widget.notification.imageUrls != null &&
                widget.notification.imageUrls!.isNotEmpty) ...[
              const Text(
                'Fotoğraflar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.notification.imageUrls!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: ColorName.inputBackground,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.image,
                        color: ColorName.loginGreyTextColor,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
            // Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorName.inputBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _InfoRow(
                    icon: Icons.access_time,
                    label: 'Oluşturulma',
                    value: widget.notification.timeAgo,
                  ),
                  if (widget.notification.userName != null)
                    _InfoRow(
                      icon: Icons.person,
                      label: 'Bildiren',
                      value: widget.notification.userName!,
                    ),
                  if (widget.notification.unit != null)
                    _InfoRow(
                      icon: Icons.business,
                      label: 'Birim',
                      value: widget.notification.unit!,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Admin Status Update
            if (widget.currentUserRole == UserRole.admin) ...[
              const Text(
                'Durum Güncelle',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _StatusButton(
                      status: NotificationStatus.open,
                      currentStatus: _currentStatus,
                      onTap: () {
                        setState(() {
                          _currentStatus = NotificationStatus.open;
                        });
                        FirebaseFirestore.instance
                            .collection('notifications')
                            .doc(widget.notification.id)
                            .update({'status': NotificationStatus.open.name});
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _StatusButton(
                      status: NotificationStatus.inProgress,
                      currentStatus: _currentStatus,
                      onTap: () {
                        setState(() {
                          _currentStatus = NotificationStatus.inProgress;
                        });
                        FirebaseFirestore.instance
                            .collection('notifications')
                            .doc(widget.notification.id)
                            .update({
                              'status': NotificationStatus.inProgress.name,
                            });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _StatusButton(
                      status: NotificationStatus.resolved,
                      currentStatus: _currentStatus,
                      onTap: () {
                        setState(() {
                          _currentStatus = NotificationStatus.resolved;
                        });
                        FirebaseFirestore.instance
                            .collection('notifications')
                            .doc(widget.notification.id)
                            .update({
                              'status': NotificationStatus.resolved.name,
                            });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
            // Follow/Unfollow button
            if (widget.currentUserRole == UserRole.user)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    if (_currentUserId == null) return;
                    setState(() {
                      _isFollowing = !_isFollowing;
                    });
                    final docRef = FirebaseFirestore.instance
                        .collection('notifications')
                        .doc(widget.notification.id);
                    if (_isFollowing) {
                      docRef.update({
                        'followingUserIds': FieldValue.arrayUnion([
                          _currentUserId,
                        ]),
                      });
                    } else {
                      docRef.update({
                        'followingUserIds': FieldValue.arrayRemove([
                          _currentUserId,
                        ]),
                      });
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _isFollowing ? 'Takip ediliyor' : 'Takip bırakıldı',
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    _isFollowing
                        ? Icons.notifications
                        : Icons.notifications_none,
                  ),
                  label: Text(_isFollowing ? 'Takipten Çık' : 'Takip Et'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _isFollowing
                        ? ColorName.goldenAccent
                        : Colors.white,
                    side: BorderSide(
                      color: _isFollowing
                          ? ColorName.goldenAccent
                          : Colors.white,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: ColorName.loginGreyTextColor),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(color: ColorName.loginGreyTextColor, fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusButton extends StatelessWidget {
  final NotificationStatus status;
  final NotificationStatus currentStatus;
  final VoidCallback onTap;

  const _StatusButton({
    required this.status,
    required this.currentStatus,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = status == currentStatus;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? status.color.withOpacity(0.2)
              : ColorName.inputBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? status.color : ColorName.inputBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            status.label,
            style: TextStyle(
              color: isSelected ? status.color : Colors.white,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
