import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:remote_home/firebase_options.dart';
import 'package:remote_home/homedata/drawer.dart';
import 'package:remote_home/main.dart';
import 'package:remote_home/drawer/about.dart';
import 'package:remote_home/drawer/instructions.dart';
import 'package:remote_home/drawer/user_info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(home_dashboard());
}

class home_dashboard extends StatelessWidget {
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
      ),
      drawer: CustomDrawer(),
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
