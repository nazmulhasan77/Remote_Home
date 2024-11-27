import 'package:flutter/material.dart';

class NewControl extends StatelessWidget {
  final TextEditingController deviceIdController = TextEditingController();
  final TextEditingController authKeyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Garage Control'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Link a New Device',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: deviceIdController,
              decoration: InputDecoration(
                labelText: 'Device ID',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.device_hub, color: Colors.teal),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: authKeyController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Device Authentication Key',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.vpn_key, color: Colors.teal),
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  String deviceId = deviceIdController.text.trim();
                  String authKey = authKeyController.text.trim();
                  
                  if (deviceId.isNotEmpty && authKey.isNotEmpty) {
                    _linkDevice(context, deviceId, authKey);
                  } else {
                    _showErrorDialog(context, 'All fields are required!');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: Text('Link Device', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _linkDevice(BuildContext context, String deviceId, String authKey) {
    // Placeholder for linking logic (e.g., API call)
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Device Linked'),
          content: Text('Device ID: $deviceId\nAuthentication Key: $authKey'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
