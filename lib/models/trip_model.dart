class TripModel {

  final String destination;
  final String notes;
  final String startDate;
  final String endDate;
  final String createdAt;
  final List members;
  final String ownerEmail;
  final List allEmails;
  final double latitude;
final double longitude;

  TripModel({
    required this.destination,
    required this.notes,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.members,
    required this.ownerEmail,
    required this.allEmails,
   required this.latitude,
required this.longitude,
  });

  Map<String, dynamic> toMap() {

    return {
      "destination": destination,
      "notes": notes,
      "startDate": startDate,
      "endDate": endDate,
      "createdAt": createdAt,
      "members": members,
      "ownerEmail": ownerEmail,
      "allEmails": allEmails,
      "latitude": latitude,
"longitude": longitude,

    };
  }
}