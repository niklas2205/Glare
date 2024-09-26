import 'package:cloud_firestore/cloud_firestore.dart';

class EventEntity {
  final String? eventId;
  final String? eventname;
  final String? picture;
  final String? description;
  final String? venue;
  final String? dj;
  final int? age;
  final DateTime? date;
  final String? venueId;
  final List<String>? eventTag;
  final String? location;
  final String? price;

  EventEntity({
    this.eventId,
    this.eventname,
    this.picture,
    this.description,
    this.venue,
    this.dj,
    this.age,
    this.date,
    this.venueId,
    this.eventTag,
    this.location,
    this.price,
  });

  Map<String, Object?> toDocument() {
    return {
      'eventId': eventId ?? 'Default Event ID',
      'eventname': eventname ?? 'Default Event Name',
      'picture': picture ?? 'Default Picture URL',
      'description': description ?? 'Default Description',
      'venue': venue ?? 'Default Venue',
      'dj': dj ?? 'Default DJ',
      'age': age ?? 0,
      'date': date != null ? Timestamp.fromDate(date!) : Timestamp.now(),
      'venueId': venueId ?? 'Default Venue ID',
      'eventTag': eventTag ?? [],
      'location': location ?? 'Default Location',
      'price': price ?? 'Default Price',
    };
  }

   static String? parsePrice(dynamic priceData) {
    if (priceData == null) return null;
    final priceString = priceData.toString();
    if (priceString.toLowerCase() == 'nan') {
      return null; // or return a default value like 'Free'
    }
    return priceString; // Keep as string if not parsing to number
  }

  static int? parseAge(dynamic ageData) {
    if (ageData == null) return null;
    if (ageData is num && !ageData.isNaN && !ageData.isInfinite) {
      return ageData.toInt();
    } else if (ageData is String) {
      final numValue = num.tryParse(ageData);
      if (numValue != null && !numValue.isNaN && !numValue.isInfinite) {
        return numValue.toInt();
      }
    }
    return null; // Return null if invalid
  }


     static EventEntity fromDocument(Map<String, dynamic> doc) {
    print("Document data: $doc");

    DateTime? date;
    if (doc['date'] is Timestamp) {
      date = (doc['date'] as Timestamp).toDate();
    } else if (doc['date'] is String) {
      date = DateTime.tryParse(doc['date']);
    } else {
      date = null; // Keep date as null if format is unexpected
    }

    return EventEntity(
      eventId: doc['eventId'] as String?,
      eventname: doc['eventname'] as String?,
      picture: doc['picture'] as String?,
      description: doc['description'] as String?,
      venue: doc['venue'] as String?,
      dj: doc['dj'] as String?,
      age: parseAge(doc['age']), // Use static method
      date: date,
      venueId: doc['venueId'] as String?,
      eventTag: doc['eventTag'] != null
          ? List<String>.from(doc['eventTag'])
          : null,
      location: doc['location'] as String?,
      price: parsePrice(doc['price']), // Use static method
    );
  }
}