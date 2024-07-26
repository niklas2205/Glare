

import 'package:event_repository/event_repository.dart';

class Event {
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

  Event({
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
      date: date,
      venueId: venueId,
      eventTag: eventTag,
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
      date: entity.date,
      venueId: entity.venueId,
      eventTag: entity.eventTag,
    );
  }
}
