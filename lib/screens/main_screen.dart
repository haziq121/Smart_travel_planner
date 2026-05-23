import 'package:flutter/material.dart';
import 'explore_screen.dart';
import 'profile_screen.dart';
import 'chat_screen.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() =>
      _MainScreenState();
}

class _MainScreenState
    extends State<MainScreen> {

  int currentIndex = 0;

 final List<Widget> screens = [

  const HomeScreen(),

  const ExploreScreen(),

 const ChatScreen(),

const ProfileScreen(),
];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: screens[currentIndex],

      bottomNavigationBar:
      BottomNavigationBar(

        currentIndex: currentIndex,

        onTap: (index) {

          setState(() {
            currentIndex = index;
          });
        },

       items: const [

  BottomNavigationBarItem(
    icon: Icon(Icons.home),
    label: "Trips",
  ),

  BottomNavigationBarItem(
    icon: Icon(Icons.explore),
    label: "Explore",
  ),

  BottomNavigationBarItem(
    icon: Icon(Icons.chat),
    label: "Chat",
  ),
  BottomNavigationBarItem(
  icon: Icon(Icons.person),
  label: "Profile",
),
],

      ),
    );
  }
}