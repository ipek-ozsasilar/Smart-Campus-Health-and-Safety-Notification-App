import 'package:flutter/material.dart';
import 'package:mobil_proje/product/constant/colors.dart';
import 'package:mobil_proje/product/enum/notification_type.dart';
import 'package:mobil_proje/product/enum/notification_status.dart';
import 'package:mobil_proje/product/model/notification_model.dart';
import 'package:mobil_proje/product/widget/input_widget.dart';
import 'package:mobil_proje/product/widget/global_elevated_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobil_proje/feature/map/location_picker_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class CreateNotificationScreen extends StatefulWidget {
  const CreateNotificationScreen({super.key, required this.onCreate});

  final void Function(NotificationModel notification) onCreate;

  @override
  State<CreateNotificationScreen> createState() =>
      _CreateNotificationScreenState();
}

class _CreateNotificationScreenState extends State<CreateNotificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  NotificationType? _selectedType;
  double? _latitude;
  double? _longitude;
  List<String> _imageUrls = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
          'Yeni Bildirim',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type Selection
              const Text(
                'Tür Seçimi',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: NotificationType.values.map((type) {
                  final isSelected = _selectedType == type;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedType = type;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? type.color.withOpacity(0.2)
                            : ColorName.inputBackground,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? type.color
                              : ColorName.inputBorder,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            type.icon,
                            color: isSelected ? type.color : Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            type.label,
                            style: TextStyle(
                              color: isSelected ? type.color : Colors.white,
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              // Title
              const Text(
                'Başlık',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              InputWidget(
                controller: _titleController,
                hintText: 'Bildirim başlığını girin',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Başlık boş olamaz';
                  }
                  return null;
                },
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
              InputWidget(
                controller: _descriptionController,
                hintText: 'Detaylı açıklama girin',
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Açıklama boş olamaz';
                  }
                  return null;
                },
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
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.map,
                            size: 48,
                            color: ColorName.loginGreyTextColor,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Harita görünümü',
                            style: TextStyle(
                              color: ColorName.loginGreyTextColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    // Cihaz konumunu kullan
                                    try {
                                      final permissionStatus = await Permission
                                          .location
                                          .request();
                                      if (!permissionStatus.isGranted) {
                                        if (mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Konum izni verilmedi',
                                              ),
                                            ),
                                          );
                                        }
                                        return;
                                      }

                                      final position =
                                          await Geolocator.getCurrentPosition(
                                            desiredAccuracy:
                                                LocationAccuracy.high,
                                          );

                                      if (mounted) {
                                        setState(() {
                                          _latitude = position.latitude;
                                          _longitude = position.longitude;
                                        });
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Cihaz konumu kullanıldı',
                                            ),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Konum alınamadı: ${e.toString()}',
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  icon: const Icon(Icons.my_location),
                                  label: const Text('Cihaz Konumu'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorName.goldenAccent,
                                    foregroundColor: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final result = await Navigator.push<LatLng>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LocationPickerScreen(),
                                      ),
                                    );

                                    if (result != null) {
                                      setState(() {
                                        _latitude = result.latitude;
                                        _longitude = result.longitude;
                                      });
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Konum seçildi'),
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.map),
                                  label: const Text('Haritadan Seç'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorName.goldenAccent,
                                    foregroundColor: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (_latitude != null && _longitude != null)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: ColorName.goldenAccent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Konum: ${_latitude!.toStringAsFixed(4)}, ${_longitude!.toStringAsFixed(4)}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Photo
              const Text(
                'Fotoğraf (Opsiyonel)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () {
                  // Mock: Fotoğraf seçimi
                  setState(() {
                    _imageUrls.add('image${_imageUrls.length + 1}');
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fotoğraf eklendi')),
                  );
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text('Fotoğraf Ekle'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: ColorName.inputBorder),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              if (_imageUrls.isNotEmpty) ...[
                const SizedBox(height: 12),
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _imageUrls.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 80,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: ColorName.inputBackground,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Icon(
                                Icons.image,
                                color: ColorName.loginGreyTextColor,
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _imageUrls.removeAt(index);
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: ColorName.errorRed,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 32),
              // Submit Button
              GlobalElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    if (_selectedType == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Lütfen bir tür seçin')),
                      );
                      return;
                    }
                    if (_latitude == null || _longitude == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Lütfen konum seçin')),
                      );
                      return;
                    }
                    // Mock: Bildirim oluşturuldu ve ana listeye eklendi
                    final currentUser = FirebaseAuth.instance.currentUser;
                    final currentUserId = currentUser?.uid ?? 'unknown';

                    String? userName;
                    String? unit;
                    if (currentUser != null) {
                      try {
                        final doc = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(currentUser.uid)
                            .get();
                        if (doc.exists && doc.data() != null) {
                          final data = doc.data()!;
                          userName = data['fullname'] as String?;
                          unit = data['unit'] as String?;
                        }
                      } catch (_) {
                        // Profil bilgisi okunamazsa yalnızca userId kaydedilir.
                      }
                    }

                    widget.onCreate(
                      NotificationModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: _titleController.text.trim(),
                        description: _descriptionController.text.trim(),
                        type: _selectedType!,
                        status: NotificationStatus.open,
                        createdAt: DateTime.now(),
                        latitude: _latitude!,
                        longitude: _longitude!,
                        userId: currentUserId,
                        userName: userName,
                        unit: unit,
                        imageUrls: _imageUrls.isEmpty ? null : _imageUrls,
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Bildirim başarıyla oluşturuldu'),
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                text: 'Bildirim Oluştur',
                loading: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
