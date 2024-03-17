

import '../entities/venue_entities.dart';

class Venue{
  String eventId;
  String eventname;
  String picture;
  String description;
  String venue;
  String address;
  String instagram;
  String website;
  


  Venue({
    required this.eventId,
    required this.eventname,
    required this.picture,
    required this.description,
    required this.venue,
    required this.address,
    required this.instagram, // Added initializer for the 'Instagram' field
    required this.website, // Added initializer for the 'Website' field
  });


  VenueEntity toEntity() {
    return VenueEntity(
      eventId: eventId,
      eventname: eventname,
      picture: picture,
      description: description,
      venue: venue,
      address: address,
      instagram: instagram, // Added initializer for the 'Instagram' field
      website: website, // Added initializer for the 'Website' field
    );
  }

  static Venue fromEntity(VenueEntity entity) {
    return Venue(
      eventId: entity.eventId,
      eventname: entity.eventname,
      picture: entity.picture,
      description: entity.description,
      venue: entity.venue,
      address: entity.address,
      instagram: entity.instagram, // Added initializer for the 'Instagram' field
      website: entity.website, // Added initializer for the 'Website' field
    );
  }
}