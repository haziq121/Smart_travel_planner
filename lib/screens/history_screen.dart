import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Trip History"),
      ),

      body: StreamBuilder(

        stream: FirebaseFirestore.instance
            .collection("trips")
            .orderBy(
          "createdAt",
          descending: true,
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
              child: Text("No History Found"),
            );
          }

          var trips = snapshot.data!.docs;

          return ListView.builder(

            itemCount: trips.length,

            itemBuilder: (context, index) {

              var trip = trips[index];

              return Card(

                margin: const EdgeInsets.all(10),

                child: ListTile(

                  leading:
                  const Icon(Icons.history),

                  title: Text(
                    trip['destination'],
                  ),

                  subtitle: Text(
                    trip['createdAt'],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}