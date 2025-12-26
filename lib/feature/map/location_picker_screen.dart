import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobil_proje/product/constant/colors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  LatLng? _selectedPosition;
  GoogleMapController? _mapController;

  // Atatürk Üniversitesi koordinatları (Erzurum)
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(39.9042, 41.2679),
    zoom: 15.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Konum Seç',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location, color: Colors.white),
            onPressed: () async {
              try {
                final permissionStatus = await Permission.location.request();
                if (!permissionStatus.isGranted) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Konum izni verilmedi')),
                    );
                  }
                  return;
                }

                final position = await Geolocator.getCurrentPosition(
                  desiredAccuracy: LocationAccuracy.high,
                );

                final newPosition = LatLng(
                  position.latitude,
                  position.longitude,
                );
                setState(() {
                  _selectedPosition = newPosition;
                });

                _mapController?.animateCamera(
                  CameraUpdate.newLatLngZoom(newPosition, 16.0),
                );

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cihaz konumuna gidildi')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Konum alınamadı: ${e.toString()}')),
                  );
                }
              }
            },
            tooltip: 'Cihaz Konumuna Git',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: _initialPosition,
              mapType: MapType.normal,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              onMapCreated: (controller) {
                _mapController = controller;
              },
              onTap: (position) {
                setState(() {
                  _selectedPosition = position;
                });
              },
              markers: _selectedPosition == null
                  ? {}
                  : {
                      Marker(
                        markerId: const MarkerId('selected'),
                        position: _selectedPosition!,
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueYellow,
                        ),
                      ),
                    },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ColorName.inputBackground,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedPosition == null
                      ? 'Haritaya dokunarak konum seçin'
                      : 'Seçilen konum: ${_selectedPosition!.latitude.toStringAsFixed(4)}, ${_selectedPosition!.longitude.toStringAsFixed(4)}',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _selectedPosition == null
                        ? null
                        : () {
                            Navigator.pop(context, _selectedPosition);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorName.goldenAccent,
                      foregroundColor: Colors.black,
                      disabledBackgroundColor: Colors.grey.withOpacity(0.5),
                    ),
                    child: const Text(
                      'Bu Konumu Kullan',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
