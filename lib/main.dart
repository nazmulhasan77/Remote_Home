import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:remote_home/authentication/login_page.dart';
import 'package:remote_home/authentication/register_page.dart';

import 'package:remote_home/firebase_options.dart';
import 'package:remote_home/homedata/home_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp1());
}

class MyApp1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => home_dashboard(),
      },
    );
  }
}
