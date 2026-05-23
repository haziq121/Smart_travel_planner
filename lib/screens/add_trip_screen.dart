import 'package:flutter/material.dart';
import '../models/trip_model.dart';
import '../services/firestore_service.dart';
import '../services/city_service.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'map_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class AddTripScreen extends StatefulWidget {
  const AddTripScreen({super.key});

  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  final TextEditingController destinationController = TextEditingController();

  final TextEditingController notesController = TextEditingController();

  final TextEditingController startDateController = TextEditingController();

  final TextEditingController endDateController = TextEditingController();
  final TextEditingController membersController = TextEditingController();

  bool isLoading = false;
  double? selectedLat;
double? selectedLng;

void saveTrip() async {

  setState(() {
    isLoading = true;
  });

  List<String> emails =

      membersController.text
          .split(",");

  List<String> validMembers = [];

  for(String email in emails) {

    var result = await FirebaseFirestore
        .instance
        .collection("users")
        .where(
          "email",
          isEqualTo: email.trim(),
        )
        .get();

    if(result.docs.isNotEmpty) {

      validMembers.add(
        email.trim(),
      );
    }
  }

  TripModel trip = TripModel(
      latitude: selectedLat!,
  longitude: selectedLng!,
    ownerEmail:
FirebaseAuth.instance
    .currentUser!
    .email!,
    allEmails: [

  FirebaseAuth.instance
      .currentUser!
      .email!,

  ...validMembers,

],

    destination:
    destinationController.text,

    notes:
    notesController.text,

    startDate:
    startDateController.text,

    endDate:
    endDateController.text,

    createdAt:
    DateTime.now().toString(),

    members:
    validMembers,
  );

  await FirestoreService()
      .addTrip(trip);

  setState(() {
    isLoading = false;
  });

  ScaffoldMessenger.of(context)
      .showSnackBar(

    const SnackBar(

      content: Text(
        "Trip Added Successfully",
      ),
    ),
  );

  Navigator.pop(context);
}

  @override
  Future<void> pickStartDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,

      initialDate: DateTime.now(),

      firstDate: DateTime(2024),

      lastDate: DateTime(2035),
    );

    if (pickedDate != null) {
      startDateController.text = pickedDate.toString().split(" ")[0];

      setState(() {});
    }
  }

  Future<void> pickEndDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,

      initialDate: DateTime.now(),

      firstDate: DateTime(2024),

      lastDate: DateTime(2035),
    );

    if (pickedDate != null) {
      endDateController.text = pickedDate.toString().split(" ")[0];

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Trip")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: SingleChildScrollView(
          child: Column(
            children: [
         TypeAheadField<dynamic>(
suggestionsCallback: (pattern) async {
  print("CALLBACK WORKING: $pattern");

  return await CityService()
      .getCities(pattern);
},

  itemBuilder: (context, suggestion) {

  return ListTile(

    title: Text(
      suggestion['city'] ?? '',
    ),

    subtitle: Text(
      suggestion['country'] ?? '',
    ),
  );
},

 onSelected: (suggestion) {

  destinationController.text =
      suggestion['city'] ?? '';

  selectedLat =
      (suggestion['latitude'] as num?)
          ?.toDouble();

  selectedLng =
      (suggestion['longitude'] as num?)
          ?.toDouble();

  setState(() {});
},

  builder: (context, controller, focusNode) {
    return TextField(
      controller: destinationController,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: "Destination",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  },
),
const SizedBox(height: 15),

if(selectedLat != null &&
    selectedLng != null)

SizedBox(

  width: double.infinity,

  child: ElevatedButton.icon(

    onPressed: () {

      Navigator.push(

        context,

        MaterialPageRoute(

          builder: (_) => MapScreen(

            latitude: selectedLat!,
            longitude: selectedLng!,

            city:
            destinationController.text,
          ),
        ),
      );
    },

    icon: const Icon(Icons.map),

    label: const Text(
      "View On Map",
    ),
  ),
),

              const SizedBox(height: 15),

              TextField(
                controller: startDateController,

                readOnly: true,

                onTap: pickStartDate,

                decoration: InputDecoration(
                  hintText: "Start Date",

                  suffixIcon: const Icon(Icons.calendar_month),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: endDateController,

                readOnly: true,

                onTap: pickEndDate,

                decoration: InputDecoration(
                  hintText: "End Date",

                  suffixIcon: const Icon(Icons.calendar_month),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: notesController,

                maxLines: 4,

                decoration: const InputDecoration(hintText: "Notes"),
              ),
              const SizedBox(height: 15),

TextField(

  controller: membersController,

  decoration: InputDecoration(

    hintText:
    "Add Members Emails",

    border: OutlineInputBorder(

      borderRadius:
      BorderRadius.circular(12),
    ),
  ),
),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: saveTrip,

                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Save Trip"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
