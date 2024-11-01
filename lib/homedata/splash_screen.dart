import 'package:flutter/material.dart';
import 'package:remote_home/authentication/login_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Define the scaling animation for the icon
    _iconAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    // Define the fade-in animation for the text
    _textAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _controller, curve: Interval(0.5, 1.0, curve: Curves.easeIn)),
    );

    // Start the animation
    _controller.forward();

    // Navigate to Home Screen after the animation finishes
    Future.delayed(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage()), // Replace with your home screen
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated icon with scale transition
            ScaleTransition(
              scale: _iconAnimation,
              child: Image.asset(
                'assets/images/app_icon.png',
                width: 150,
                height: 150,
              ),
            ),
            SizedBox(height: 20),
            // Text with fade-in effect
            FadeTransition(
              opacity: _textAnimation,
              child: Text(
                "Your Home in Your Hand!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
