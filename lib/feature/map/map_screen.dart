import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobil_proje/product/constant/colors.dart';
import 'package:mobil_proje/product/enum/notification_type.dart';
import 'package:mobil_proje/product/model/notification_model.dart';
import 'package:mobil_proje/product/mixin/navigation_mixin.dart';
import 'package:mobil_proje/feature/notification/notification_detail_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    required this.notifications,
    this.showAppBar = true,
  });

  final List<NotificationModel> notifications;
  final bool showAppBar;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  String? _mapError;
  bool _isMapLoading = true;

  // Atatürk Üniversitesi koordinatları (Erzurum)
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(39.9042, 41.2679),
    zoom: 15.0,
  );

  NotificationModel? _selectedNotification;

  Set<Marker> get _markers {
    return widget.notifications.map((notification) {
      return Marker(
        markerId: MarkerId(notification.id),
        position: LatLng(notification.latitude, notification.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          _getMarkerHue(notification.type),
        ),
        infoWindow: InfoWindow(
          title: notification.title,
          snippet: notification.type.label,
        ),
        onTap: () {
          setState(() {
            _selectedNotification = notification;
          });
        },
      );
    }).toSet();
  }

  double _getMarkerHue(NotificationType type) {
    switch (type) {
      case NotificationType.security:
        return BitmapDescriptor.hueYellow; // Golden
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

  // Dark theme için map style (şimdilik kullanılmıyor, harita çalıştıktan sonra açılabilir)
  // ignore: unused_element
  String get _mapStyle => '''
  [
    {
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#242f3e"
        }
      ]
    },
    {
      "elementType": "labels.text.stroke",
      "stylers": [
        {
          "color": "#242f3e"
        }
      ]
    },
    {
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#746855"
        }
      ]
    },
    {
      "featureType": "administrative.locality",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#d59563"
        }
      ]
    },
    {
      "featureType": "poi",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#d59563"
        }
      ]
    },
    {
      "featureType": "poi.park",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#263c3f"
        }
      ]
    },
    {
      "featureType": "poi.park",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#6b9a76"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#38414e"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "geometry.stroke",
      "stylers": [
        {
          "color": "#212a37"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#9ca5b3"
        }
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#746855"
        }
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry.stroke",
      "stylers": [
        {
          "color": "#1f2835"
        }
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#f3d19c"
        }
      ]
    },
    {
      "featureType": "transit",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#2f3948"
        }
      ]
    },
    {
      "featureType": "transit.station",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#d59563"
        }
      ]
    },
    {
      "featureType": "water",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#17263c"
        }
      ]
    },
    {
      "featureType": "water",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#515c6d"
        }
      ]
    },
    {
      "featureType": "water",
      "elementType": "labels.text.stroke",
      "stylers": [
        {
          "color": "#17263c"
        }
      ]
    }
  ]
  ''';

  @override
  Widget build(BuildContext context) {
    final mapBody = _mapError != null
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Harita yüklenemedi',
                  style: TextStyle(
                    color: ColorName.loginGreyTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    _mapError!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorName.loginGreyTextColor,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _mapError = null;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorName.goldenAccent,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Tekrar Dene'),
                ),
              ],
            ),
          )
        : Stack(
            children: [
              // Google Maps
              GoogleMap(
                onMapCreated: (GoogleMapController controller) async {
                  _mapController = controller;
                  // Harita başarıyla yüklendi
                  debugPrint('✅ Google Maps controller oluşturuldu');
                  debugPrint('📍 Initial position: ${_initialPosition.target}');
                  debugPrint('📍 Markers count: ${_markers.length}');

                  // Kısa bir beklemeden sonra "yükleniyor" etiketini kaldır
                  // (gerçek cihazda harita zaten yüklenmiş oluyor)
                  Future.delayed(const Duration(seconds: 1), () {
                    if (!mounted) return;
                    setState(() {
                      _isMapLoading = false;
                    });
                  });

                  // Style'ı geçici olarak kapat - test için
                  // Harita çalıştıktan sonra tekrar açabilirsiniz
                  // controller.setMapStyle(_mapStyle).catchError((error) {
                  //   debugPrint('❌ Map style error: $error');
                  // });
                },
                initialCameraPosition: _initialPosition,
                markers: _markers,
                mapType: MapType.normal,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                compassEnabled: false,
                mapToolbarEnabled: false,
                rotateGesturesEnabled: true,
                scrollGesturesEnabled: true,
                tiltGesturesEnabled: false,
                zoomGesturesEnabled: true,
                onTap: (LatLng position) {
                  setState(() {
                    _selectedNotification = null;
                  });
                },
              ),
              // Yükleniyor göstergesi
              if (_isMapLoading)
                Positioned(
                  top: 20,
                  left: 0,
                  right: 0,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: ColorName.goldenAccent,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Harita yükleniyor...',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              // Seçili bildirim kartı
              if (_selectedNotification != null)
                Positioned(
                  bottom: 20,
                  left: 16,
                  right: 16,
                  child: _PinInfoCard(
                    notification: _selectedNotification!,
                    onDetailTap: () {
                      context.navigateTo(
                        NotificationDetailScreen(
                          notification: _selectedNotification!,
                        ),
                      );
                    },
                    onClose: () {
                      setState(() {
                        _selectedNotification = null;
                      });
                    },
                  ),
                ),
            ],
          );

    if (!widget.showAppBar) {
      // Harita, dıştaki Scaffold içinde (ör. HomeScreen) gösteriliyorsa
      // sadece gövdeyi döndür.
      return mapBody;
    }

    return Scaffold(
      backgroundColor: ColorName.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Harita',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location, color: Colors.white),
            onPressed: () {
              _mapController?.animateCamera(
                CameraUpdate.newCameraPosition(_initialPosition),
              );
            },
            tooltip: 'Kampüse Git',
          ),
        ],
      ),
      body: mapBody,
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
                  child: Icon(
                    notification.type.icon,
                    color: notification.type.color,
                    size: 18,
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Detayı Gör',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
