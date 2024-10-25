import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:remote_home/firebase_options.dart';
import 'package:remote_home/pages/about.dart';
import 'package:remote_home/pages/instructions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Automation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref('data');
  bool switch1 = false;
  bool switch2 = false;

  @override
  void initState() {
    super.initState();
    _loadSwitchValues();
  }

  void _loadSwitchValues() {
    _databaseReference.child('switch1').onValue.listen((event) {
      setState(() {
        switch1 = event.snapshot.value == 1;
      });
    });

    _databaseReference.child('switch2').onValue.listen((event) {
      setState(() {
        switch2 = event.snapshot.value == 1;
      });
    });
  }

  void _updateSwitch1(bool value) {
    setState(() {
      switch1 = value;
    });
    _databaseReference.child('switch1').set(value ? 1 : 0);
  }

  void _updateSwitch2(bool value) {
    setState(() {
      switch2 = value;
    });
    _databaseReference.child('switch2').set(value ? 1 : 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(' Remotely Control your Device'),
        /** actions: [
          IconButton(
            icon: Icon(Icons.lightbulb),
            onPressed: () {
              // Add functionality for controlling lights.
            },
          ),
          IconButton(
            icon: Icon(Icons.thermostat),
            onPressed: () {
              // Add functionality for controlling temperature.
            },
          ),
          IconButton(
            icon: Icon(Icons.lock),
            onPressed: () {
              // Add functionality for controlling locks.
            },
          ),
        ], **/
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
                // Add navigation to Firebase About page.
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('User List'),
              onTap: () {
                // Add navigation to User List page.
              },
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Instructions'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GuidelinesPage()),
                );
                // Add navigation to Instructions page.
              },
            ),
            Divider(), // A divider to separate the logout from other items.
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  // Navigate to the login page or display a message
                  Navigator.of(context).pushReplacementNamed('/login');
                } catch (e) {
                  // Handle logout error if any
                  print('Logout error: $e');
                }
              },
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Switch 1'),
                      Switch(
                        value: switch1,
                        onChanged: _updateSwitch1,
                      ),
                    ],
                  ),
                  if (switch1)
                    Image.asset(
                      'assets/images/on.png',
                      width: 100,
                      height: 100,
                    )
                  else
                    Image.asset(
                      'assets/images/off.png',
                      width: 100,
                      height: 100,
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Switch 2'),
                      Switch(
                        value: switch2,
                        onChanged: _updateSwitch2,
                      ),
                    ],
                  ),
                  if (switch2)
                    Image.asset(
                      'assets/images/fan_on.gif',
                      width: 100,
                      height: 100,
                    )
                  else
                    Image.asset(
                      'assets/images/fan_off.png',
                      width: 100,
                      height: 100,
                    ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.blue.shade50,
            child: Text(
              'Developed By Nazmul Hasan RU CSE-29',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
