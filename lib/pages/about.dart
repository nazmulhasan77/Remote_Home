import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Automation About',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AboutPage(),
    );
  }
}

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  Map<String, dynamic>? about;

  @override
  void initState() {
    super.initState();
    loadAbout();
  }

  Future<void> loadAbout() async {
    final String response = await rootBundle.loadString('assets/about.json');
    final data = await json.decode(response);
    setState(() {
      about = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About Home Automation')),
      body: about == null
          ? Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                Text('Project Name', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(about!['Project Name']),
                Divider(),
                Text('Objective', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(about!['Objective']),
                Divider(),
                Text('Overview', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(about!['Overview']),
                Divider(),
                Text('Key Components', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ...about!['Key Components'].entries.map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry.key, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text(entry.value),
                      Divider(),
                    ],
                  );
                }).toList(),
                Text('How the System Works', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ...about!['How the System Works'].map<Widget>((step) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(step['Step'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text(step['Description']),
                      Divider(),
                    ],
                  );
                }).toList(),
                Text('Benefits', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ...about!['Benefits'].map<Widget>((benefit) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('- $benefit'),
                    ],
                  );
                }).toList(),
                Divider(),
                Text('Applications', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ...about!['Applications'].map<Widget>((application) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('- $application'),
                    ],
                  );
                }).toList(),
                Divider(),
                Text('Future Enhancements', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ...about!['Future Enhancements'].map<Widget>((enhancement) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('- $enhancement'),
                    ],
                  );
                }).toList(),
              ],
            ),
    );
  }
}
