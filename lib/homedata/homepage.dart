import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:remote_home/NewControl.dart';
import 'package:remote_home/homedata/control_dashboard.dart';
import 'package:remote_home/homedata/control_dashboard_default.dart';
import 'package:remote_home/homedata/drawer.dart';

void main() {
  runApp(RemoteHome());
}

class RemoteHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remote Control App',
      theme: ThemeData(
        hintColor: Colors.amber,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> items = [
    {'name': 'Bedroom', 'icon': FontAwesomeIcons.bed},
    {'name': 'Kitchen', 'icon': FontAwesomeIcons.utensils},
    {'name': 'Garage', 'icon': FontAwesomeIcons.car},
    {'name': 'Bathroom', 'icon': FontAwesomeIcons.bath},
    {'name': 'Office', 'icon': FontAwesomeIcons.laptop},
    {'name': 'Garden', 'icon': FontAwesomeIcons.leaf},
  ];

  final TextEditingController passwordController = TextEditingController();
  final String correctPassword = "1122";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Remotely Control your Device'),
      ),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Control Your Spaces',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (items[index]['name'] == 'Bedroom') {
                      _showPasswordDialog(context);
                    } else if (items[index]['name'] == 'Garage') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NewControl(), // Navigate to NewControl page
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ControlDashboard(),
                        ),
                      );
                    }
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          items[index]['icon'],
                          size: 50,
                          color: Colors.teal,
                        ),
                        SizedBox(height: 10),
                        Text(
                          items[index]['name'],
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.teal),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enter Security Code"),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(hintText: "Security Code"),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("OK"),
              onPressed: () {
                if (passwordController.text == correctPassword) {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => control_dashboard(),
                    ),
                  );
                } else {
                  Navigator.of(context).pop();
                  _showErrorDialog(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Incorrect Security Code"),
          content: Text(" Try Again ! "),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                _showPasswordDialog(context); // Reopen the password dialog
              },
            ),
          ],
        );
      },
    );
  }
}
