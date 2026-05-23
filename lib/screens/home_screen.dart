import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'edit_trip_screen.dart';
import 'add_trip_screen.dart';
import 'weather_screen.dart';
import 'chat_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {
      final TextEditingController
searchController =
TextEditingController();

String searchText = "";

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;
    String currentEmail =
    user?.email ?? "";

    return Scaffold(

      appBar: AppBar(
        title: const Text("Smart Travel Planner"),
        centerTitle: true,

       actions: [

  IconButton(

    onPressed: () {

      Navigator.push(
        context,

        MaterialPageRoute(
          builder: (_) => const ChatScreen(),
        ),
      );
    },

    icon: const Icon(Icons.chat),
  ),

  IconButton(

    onPressed: () async {

      await FirebaseAuth.instance.signOut();

      Navigator.pop(context);
    },

    icon: const Icon(Icons.logout),
  ),
],
      ),

      floatingActionButton: FloatingActionButton(

        onPressed: () {

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddTripScreen(),
            ),
          );
        },

        child: const Icon(Icons.add),
      ),

     body: Column(

  children: [

    Padding(

      padding: const EdgeInsets.all(12),

      child: TextField(

        controller: searchController,

        onChanged: (value) {

          setState(() {

            searchText =
                value.toLowerCase();
          });
        },

        decoration: InputDecoration(

          hintText: "Search Trips",

          prefixIcon:
          const Icon(Icons.search),

          border: OutlineInputBorder(

            borderRadius:
            BorderRadius.circular(15),
          ),
        ),
      ),
    ),

    Expanded(

      child: StreamBuilder(

        stream: FirebaseFirestore.instance
      .collection("trips")
.where(

  "allEmails",

  arrayContains:
  currentEmail,
)
.snapshots(),

        builder: (context, snapshot) {

          if(snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if(!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {

            return const Center(
              child: Text(
                "No Trips Added Yet",
                style: TextStyle(fontSize: 20),
              ),
            );
          }

          var trips =
          snapshot.data!.docs.where((trip) {

            String destination =
            trip['destination']
                .toString()
                .toLowerCase();

            return destination.contains(
              searchText,
            );

          }).toList();

          return ListView.builder(

            itemCount: trips.length,

            itemBuilder: (context, index) {

              var trip = trips[index];

              return Container(

                margin:
                const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),

                decoration: BoxDecoration(

                  gradient:
                  const LinearGradient(

                    colors: [
                      Colors.blue,
                      Colors.purple,
                    ],
                  ),

                  borderRadius:
                  BorderRadius.circular(18),

                  boxShadow: [

                    BoxShadow(

                      color: Colors.black
                          .withOpacity(0.2),

                      blurRadius: 6,

                      offset:
                      const Offset(0, 3),
                    ),
                  ],
                ),

                child: ListTile(

                  contentPadding:
                  const EdgeInsets.all(15),

                  onTap: () {

                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (_) =>
                            EditTripScreen(

                              tripId: trip.id,

                              destination:
                              trip['destination'],

                              startDate:
                              trip['startDate'],

                              endDate:
                              trip['endDate'],

                              notes:
                              trip['notes'],
                            ),
                      ),
                    );
                  },

                  leading:
                  const CircleAvatar(

                    backgroundColor:
                    Colors.white,

                    child: Icon(
                      Icons.flight,
                      color: Colors.blue,
                    ),
                  ),

                  title: Text(

                    trip['destination'],

                    style: const TextStyle(

                      color: Colors.white,

                      fontWeight:
                      FontWeight.bold,

                      fontSize: 18,
                    ),
                  ),

                 subtitle: Column(

  crossAxisAlignment:
  CrossAxisAlignment.start,

  children: [

    const SizedBox(height: 8),

    Text(

      "${trip['startDate']} → ${trip['endDate']}",

      style: const TextStyle(
        color: Colors.white70,
      ),
    ),

    const SizedBox(height: 10),

    const Text(

      "Members:",

      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),

    const SizedBox(height: 6),

    Wrap(

      spacing: 6,

      runSpacing: 6,

      children: List.generate(

        trip['members'].length,

        (index) {

          return Chip(

            backgroundColor:
            Colors.white,

            label: Text(

              trip['members'][index],

              style: const TextStyle(
                fontSize: 11,
              ),
            ),
          );
        },
      ),
    ),
  ],
),

                  trailing: Row(

                    mainAxisSize:
                    MainAxisSize.min,

                    children: [

                      IconButton(

   onPressed: () {

  final data =
      trip.data() as Map<String, dynamic>;

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => WeatherScreen(

        latitude:
            (data['latitude'] ?? 0).toDouble(),

        longitude:
            (data['longitude'] ?? 0).toDouble(),
      ),
    ),
  );
},

                        icon: const Icon(
                          Icons.cloud,
                          color: Colors.white,
                        ),
                      ),

                      IconButton(

                        onPressed: () async {

                          await FirebaseFirestore
                              .instance
                              .collection("trips")
                              .doc(trip.id)
                              .delete();
                        },

                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    ),
  ],
),
    );
  }
}