class VenueEntity {
  String eventId;
  String eventname;
  String picture;
  String description;
  String venue;
  String address;
  String instagram;
  String website;
  

  VenueEntity({
    required this.eventId,
    required this.eventname,
    required this.picture,
    required this.description,
    required this.venue,
    required this.address,
    required this.instagram, // Added initializer for the 'Instagram' field
    required this.website, // Added initializer for the 'Website' field
  });

  Map<String, Object?> toDocument() {
    return {
      'eventId':  eventId,
      'eventname':  eventname,
      'picture':  picture,
      'description':  description,
      'venue':  venue,
      'address':  address,
      'instagram':  instagram, // Added initializer for the 'Instagram' field
      'website':  website, // Added initializer for the 'Website' field
    };
  }

  static VenueEntity fromDocument(Map<String, dynamic> doc) {
    return VenueEntity(
      eventId: doc['eventId'],
      eventname: doc['eventname'],
      picture: doc['picture'],
      description: doc['description'],
      venue: doc['venue'],
      address: doc['address'],
      instagram: doc['instagram'], // Added initializer for the 'Instagram' field
      website: doc['website'], // Added initializer for the 'Website' field
    );
  }
}