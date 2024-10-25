import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:remote_home/firebase_options.dart';

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
        title: Text('Home Automation'),
      ),
      body: Center(
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
          ],
        ),
      ),
    );
  }
}
