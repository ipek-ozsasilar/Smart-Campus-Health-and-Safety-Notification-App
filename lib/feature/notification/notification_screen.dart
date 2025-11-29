import 'package:flutter/material.dart';
import 'package:mobil_proje/feature/login/login_screen.dart';
class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue, title: Text('appbar')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Notification'),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LogInView();
                  },
                ),
              );
            },
            child: const Text('Geri Dön'),
          ),
          const Text("data"),
        ],
      ),
    );
  }
}
