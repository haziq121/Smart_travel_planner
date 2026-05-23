import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditTripScreen extends StatefulWidget {

  final String tripId;
  final String destination;
  final String startDate;
  final String endDate;
  final String notes;

  const EditTripScreen({
    super.key,
    required this.tripId,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.notes,
  });

  @override
  State<EditTripScreen> createState() =>
      _EditTripScreenState();
}

class _EditTripScreenState
    extends State<EditTripScreen> {

  late TextEditingController destinationController;
  late TextEditingController startDateController;
  late TextEditingController endDateController;
  late TextEditingController notesController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    destinationController =
        TextEditingController(
      text: widget.destination,
    );

    startDateController =
        TextEditingController(
      text: widget.startDate,
    );

    endDateController =
        TextEditingController(
      text: widget.endDate,
    );

    notesController =
        TextEditingController(
      text: widget.notes,
    );
  }

  void updateTrip() async {

    setState(() {
      isLoading = true;
    });

    await FirebaseFirestore.instance
        .collection("trips")
        .doc(widget.tripId)
        .update({

      "destination":
      destinationController.text,

      "startDate":
      startDateController.text,

      "endDate":
      endDateController.text,

      "notes":
      notesController.text,
    });

    setState(() {
      isLoading = false;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Edit Trip"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: SingleChildScrollView(

          child: Column(

            children: [

              TextField(
                controller: destinationController,

                decoration: const InputDecoration(
                  hintText: "Destination",
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: startDateController,

                decoration: const InputDecoration(
                  hintText: "Start Date",
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: endDateController,

                decoration: const InputDecoration(
                  hintText: "End Date",
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: notesController,

                maxLines: 4,

                decoration: const InputDecoration(
                  hintText: "Notes",
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: updateTrip,

                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Update Trip"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}