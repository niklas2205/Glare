

import 'package:event_repository/event_repository.dart';

import 'package:event_repository/event_repository.dart';

class Event {
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

  Event({
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
      location: location,
      price: price,
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
      location: entity.location,
      price: entity.price,
    );
  }
}
