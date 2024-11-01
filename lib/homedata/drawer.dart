import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remote_home/main.dart';
import 'package:remote_home/drawer/about.dart';
import 'package:remote_home/drawer/instructions.dart';
import 'package:remote_home/drawer/user_info.dart';

class CustomDrawer extends StatelessWidget {
  final String headerImageUrl = 'https://i.ibb.co.com/k4WL8LN/header.png';
  final String profileImageUrl =
      'https://i.ibb.co.com/ZYysvL3/profile-pic.png'; // Add your custom image URL here

  Future<Map<String, String>> _getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return {
        'name': userDoc['name'] ?? 'Guest User',
        'email': userDoc['email'] ?? 'No email available',
      };
    }
    return {'name': 'Guest User', 'email': 'No email available'};
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Custom Drawer Header with Image, Name, and Email
          FutureBuilder<Map<String, String>>(
            future: _getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    image: DecorationImage(
                      image: NetworkImage(headerImageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError || !snapshot.hasData) {
                return DrawerHeader(
                  child: Center(child: Text('Error loading user data')),
                );
              }

              final userData = snapshot.data!;
              return UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.white, // Set header background color to white
                  image: DecorationImage(
                    image: NetworkImage(headerImageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                accountName: Text(
                  userData['name']!,
                  style: TextStyle(
                      color: const Color.fromARGB(255, 6, 6, 6),
                      fontSize: 18), // Updated text color
                ),
                accountEmail: Text(
                  userData['email']!,
                  style: TextStyle(color: const Color.fromARGB(135, 0, 0, 0)),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage:
                      NetworkImage(profileImageUrl), // Custom profile image
                  backgroundColor: Colors
                      .transparent, // Transparent background for the image
                ),
              );
            },
          ),

          // Drawer Options
          Expanded(
            child: ListView(
              children: [
                CustomListTile(
                  icon: Icons.info,
                  title: 'About',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutPage()),
                    );
                  },
                ),
                CustomListTile(
                  icon: Icons.people,
                  title: 'User List',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserListPage()),
                    );
                  },
                ),
                CustomListTile(
                  icon: Icons.help,
                  title: 'Instructions',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GuidelinesPage()),
                    );
                  },
                ),
                Divider(), // A divider to separate sections
              ],
            ),
          ),

          // Logout Option at the Bottom
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ListTile(
              leading: Icon(Icons.logout, color: Colors.redAccent),
              title: Text(
                'Logout',
                style: TextStyle(color: Colors.redAccent),
              ),
              onTap: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Logged out successfully')),
                  );
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => MyApp1()),
                    (Route<dynamic> route) => false,
                  );
                } catch (e) {
                  print('Logout error: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Logout error: $e')),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Custom ListTile widget for reusability
class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  CustomListTile(
      {required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      onTap: onTap,
    );
  }
}
