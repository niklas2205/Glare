

import 'package:event_repository/event_repository.dart';

class Event {
  String eventId;
  String eventname;
  String picture;
  String description;
  String venue;
  String dj;
  int age;
  DateTime date; // Add the date field

  Event({
    required this.eventId,
    required this.eventname,
    required this.picture,
    required this.description,
    required this.venue,
    required this.dj,
    required this.age,
    required this.date, // Initialize the date field
  });

  EventEntity toEntity() {
    return EventEntity(
      eventId: eventId,
      eventname: eventname,
      picture: picture,
      description: description,
      venue: venue,
      dj: dj,
      age: age,
      date: date, // Add the date field
    );
  }

  static Event fromEntity(EventEntity entity) {
    return Event(
      eventId: entity.eventId,
      eventname: entity.eventname,
      picture: entity.picture,
      description: entity.description,
      venue: entity.venue,
      dj: entity.dj,
      age: entity.age,
      date: entity.date, // Add the date field
    );
  }
}