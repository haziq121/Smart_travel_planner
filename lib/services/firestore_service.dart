import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/trip_model.dart';

class FirestoreService {

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> addTrip(TripModel trip) async {

    await _firestore.collection("trips").add(
      trip.toMap(),
    );
  }
}