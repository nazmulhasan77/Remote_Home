import 'package:flutter/material.dart';
import 'package:remote_home/drawer/instructions.dart';

class ControlDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Remotely Control your Device'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome to the Control Dashboard! For adding a new device, follow the instructions on the Guidelines page.",
              style: TextStyle(fontSize: 24, color: Colors.teal),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20), // Spacing between text and button
            Container(
              padding: EdgeInsets.all(10), // Inner padding of the box
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.teal, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GuidelinesPage(),
                    ),
                  );
                },
                child: Text(
                  "Go to Guidelines Page",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
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
