import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:remote_home/firebase_options.dart';
import 'package:remote_home/homedata/drawer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(control_dashboard());
}

class control_dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Automation',
      theme: ThemeData(
        primarySwatch: Colors.teal,
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
        title: Text('Home Automation Control'),
        centerTitle: true,
      ),
      drawer: CustomDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Bedroom Header
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                Icon(
                  FontAwesomeIcons.bed,
                  color: Colors.teal,
                  size: 60,
                ),
                SizedBox(height: 10),
                Text(
                  'Bedroom',
                  style: TextStyle(
                    fontSize: 36,
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Switch Controls
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Switch 1 Control Card
                  _buildSwitchControl(
                    'Light',
                    switch1,
                    _updateSwitch1,
                    'assets/images/on.png',
                    'assets/images/off.png',
                  ),
                  SizedBox(height: 20),

                  // Switch 2 Control Card
                  _buildSwitchControl(
                    'Fan',
                    switch2,
                    _updateSwitch2,
                    'assets/images/fan_on.gif',
                    'assets/images/fan_off.png',
                  ),
                ],
              ),
            ),
          ),

          // Footer
        ],
      ),
    );
  }

  // Widget for the Switch Control UI
  Widget _buildSwitchControl(String label, bool switchValue,
      ValueChanged<bool> onChanged, String onImage, String offImage) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                SizedBox(height: 8),
                Image.asset(
                  switchValue ? onImage : offImage,
                  width: 80,
                  height: 80,
                ),
              ],
            ),
            Switch(
              value: switchValue,
              onChanged: onChanged,
              activeColor: Colors.teal,
              inactiveTrackColor: Colors.grey.shade300,
            ),
          ],
        ),
      ),
    );
  }
}
