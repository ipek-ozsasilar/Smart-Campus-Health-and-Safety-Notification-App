import 'package:flutter/material.dart';
import 'package:mobil_proje/feature/login/login_screen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('appbar'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Notification'),
          TextButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              var loginScreen = LoginScreen();
              return loginScreen;
            }));
          }, child: Text('Geri Dön')),
             Text("data")
          
        ],
      ),
    );
  }
}