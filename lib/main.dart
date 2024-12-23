import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:remote_home/authentication/login_page.dart';
import 'package:remote_home/authentication/register_page.dart';
import 'package:remote_home/firebase_options.dart';
import 'package:remote_home/homedata/homepage.dart';
import 'package:remote_home/homedata/splash_screen.dart';

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
      title: 'Remote Home',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Check if the user is logged in and set the initial route accordingly
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? '/login' : '/splash',
      routes: {
        '/login': (context) => LoginPage(),
        '/splash': (context) => SplashScreen(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => RemoteHome(),
      },
    );
  }
}
