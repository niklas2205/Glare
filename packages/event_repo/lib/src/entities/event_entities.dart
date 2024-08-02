import 'package:cloud_firestore/cloud_firestore.dart';

class EventEntity {
  String eventId;
  String eventname;
  String picture;
  String description;
  String venue;
  String dj;
  int age;
  DateTime date;
  String venueId;
  List<String> eventTag;
  String location;
  String price;

  EventEntity({
    required this.eventId,
    required this.eventname,
    required this.picture,
    required this.description,
    required this.venue,
    required this.dj,
    required this.age,
    required this.date,
    required this.venueId,
    required this.eventTag,
    required this.location,
    required this.price,
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
      'venueId': venueId,
      'eventTag': eventTag,
      'location': location,
      'price': price,
    };
  }

  static EventEntity fromDocument(Map<String, dynamic> doc) {
    print("Document data: $doc");

    DateTime date;
    if (doc['date'] is Timestamp) {
      date = (doc['date'] as Timestamp).toDate();
    } else if (doc['date'] is String) {
      date = DateTime.parse(doc['date']);
    } else {
      date = DateTime.now(); // default value if date format is unexpected
    }

    return EventEntity(
      eventId: doc['eventId'] ?? 'Default Event ID',
      eventname: doc['eventname'] ?? 'Default Event Name',
      picture: doc['picture'] ?? 'Default Picture URL',
      description: doc['description'] ?? 'Default Description',
      venue: doc['venue'] ?? 'Default Venue',
      dj: doc['dj'] ?? 'Default DJ',
      age: doc['age'] ?? 0,
      date: date, // Handle both Timestamp and ISO string
      venueId: doc['venueId'] ?? 'Default Venue ID',
      eventTag: List<String>.from(doc['eventTag'] ?? []), // Add the eventTag field
      location: doc['location'] ?? 'Default Location',
      price: doc['price'] ?? 'Default Price',
    );
  }
}