import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobil_proje/product/constant/colors.dart';
import 'package:mobil_proje/product/widget/input_widget.dart';
import 'package:mobil_proje/product/widget/global_elevated_button.dart';

class EmergencyAlertScreen extends StatefulWidget {
  const EmergencyAlertScreen({super.key});

  @override
  State<EmergencyAlertScreen> createState() => _EmergencyAlertScreenState();
}

class _EmergencyAlertScreenState extends State<EmergencyAlertScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
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
          'Acil Durum Bildirimi',
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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ColorName.errorRed.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ColorName.errorRed, width: 2),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: ColorName.errorRed, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Bu bildirim tüm kullanıcılara gönderilecektir',
                        style: TextStyle(
                          color: ColorName.errorRed,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
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
                hintText: 'Acil durum başlığı',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Başlık boş olamaz';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Mesaj',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              InputWidget(
                controller: _messageController,
                hintText: 'Acil durum mesajı',
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mesaj boş olamaz';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              GlobalElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final adminId =
                        FirebaseAuth.instance.currentUser?.uid ?? 'admin';
                    FirebaseFirestore.instance
                        .collection('emergencyAlerts')
                        .add({
                          'title': _titleController.text.trim(),
                          'message': _messageController.text.trim(),
                          'createdAt': DateTime.now(),
                          'createdBy': adminId,
                          'isActive': true,
                          'priority': 'high',
                        })
                        .then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Acil durum bildirimi tüm kullanıcılara gönderildi',
                              ),
                              backgroundColor: ColorName.errorRed,
                            ),
                          );
                          Navigator.pop(context);
                        });
                  }
                },
                text: 'Bildirimi Yayınla',
                loading: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}