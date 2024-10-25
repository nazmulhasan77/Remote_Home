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
      title: 'Home Automation Guidelines',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: GuidelinesPage(),
    );
  }
}

class GuidelinesPage extends StatefulWidget {
  @override
  _GuidelinesPageState createState() => _GuidelinesPageState();
}

class _GuidelinesPageState extends State<GuidelinesPage> {
  Map<String, dynamic>? guidelines;

  @override
  void initState() {
    super.initState();
    loadGuidelines();
  }

  Future<void> loadGuidelines() async {
    final String response =
        await rootBundle.loadString('assets/guidelines.json');
    final data = await json.decode(response);
    setState(() {
      guidelines = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Automation Guidelines')),
      body: guidelines == null
          ? Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                Text('Project Overview',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(guidelines!['Project Overview']),
                Divider(),
                Text('Requirements',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                for (var item in guidelines!['Requirements']['Hardware']) ...[
                  Text('- $item'),
                ],
                Divider(),
                for (var item in guidelines!['Requirements']['Software']) ...[
                  Text('- $item'),
                ],
                Divider(),
                Text('Setup Instructions',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                for (var setup
                    in guidelines!['Setup Instructions'].entries) ...[
                  Text(setup.key,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  for (var instruction in setup.value) ...[
                    Text('- $instruction'),
                  ],
                  Divider(),
                ],
                Text('Conclusion',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(guidelines!['Conclusion']),
              ],
            ),
    );
  }
}
