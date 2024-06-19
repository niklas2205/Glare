import 'package:cloud_firestore/cloud_firestore.dart';

class EventEntity {
  String eventId;
  String eventname;
  String picture;
  String description;
  String venue;
  String dj;
  int age;
  DateTime date; // Add the date field

  EventEntity({
    required this.eventId,
    required this.eventname,
    required this.picture,
    required this.description,
    required this.venue,
    required this.dj,
    required this.age,
    required this.date, // Initialize the date field
  });

  Map<String, Object?> toDocument() {
    return {
      'eventId': eventId,
      'eventname': eventname,
      'picture': picture,
      'description': description,
      'venue': venue,
      'dj': dj,
      'age': age,
      'date': Timestamp.fromDate(date), // Store the date as a Firestore Timestamp
    };
  }

  static EventEntity fromDocument(Map<String, dynamic> doc) {
    return EventEntity(
      eventId: doc['eventId'],
      eventname: doc['eventname'],
      picture: doc['picture'],
      description: doc['description'],
      venue: doc['venue'],
      dj: doc['dj'],
      age: doc['age'],
      date: (doc['date'] as Timestamp).toDate(), // Convert the Timestamp back to DateTime
    );
  }
}