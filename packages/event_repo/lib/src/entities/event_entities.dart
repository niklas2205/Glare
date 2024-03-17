class EventEntity {
  String eventId;
  String eventname;
  String picture;
  String description;
  String venue;
  String dj;
  int age;

  EventEntity({
    required this.eventId,
    required this.eventname,
    required this.picture,
    required this.description,
    required this.venue,
    required this.dj,
    required this.age,
  });

  Map<String, Object?> toDocument() {
    return {
      'eventId':  eventId,
      'eventname':  eventname,
      'picture':  picture,
      'description':  description,
      'venue':  venue,
      'dj': dj,
      'age': age,
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
    );
  }
}