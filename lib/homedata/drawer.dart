import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:remote_home/main.dart';
import 'package:remote_home/drawer/about.dart';
import 'package:remote_home/drawer/instructions.dart';
import 'package:remote_home/drawer/user_info.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Custom Drawer Header
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              image: DecorationImage(
                image: AssetImage('assets/header_background.png'), // Background image
                fit: BoxFit.cover,
              ),
            ),
            accountName: Text(
              'John Doe',
              style: TextStyle(color: Colors.white),
            ),
            accountEmail: Text(
              'john.doe@example.com',
              style: TextStyle(color: Colors.white70),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/profile_picture.png'), // Profile picture
            ),
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

  CustomListTile({required this.icon, required this.title, required this.onTap});

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
