import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final user =
        FirebaseAuth.instance.currentUser;

    return Scaffold(

      appBar: AppBar(
        title: const Text("Profile"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            const CircleAvatar(
              radius: 40,
              child: Icon(
                Icons.person,
                size: 40,
              ),
            ),

            const SizedBox(height: 20),

            Text(

              user?.email ?? "",

              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            ListTile(

              leading:
              const Icon(Icons.history),

              title:
              const Text("Trip History"),

              trailing:
              const Icon(Icons.arrow_forward_ios),

              onTap: () {

                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (_) =>
                    const HistoryScreen(),
                  ),
                );
              },
            ),

            const Divider(),

            ListTile(

              leading:
              const Icon(Icons.logout),

              title:
              const Text("Logout"),

              onTap: () async {

                await FirebaseAuth.instance
                    .signOut();

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}