

import '../entities/venue_entities.dart';

class Venue {
  String venueId;
  String venuename;
  String picture;
  String description;
  String address;
  String instagram;
  String website;
  int reviews; 
  List<String> eventIds; // New field

  Venue({
    required this.venueId,
    required this.venuename,
    required this.picture,
    required this.description,
    required this.address,
    required this.instagram,
    required this.website,
    required this.reviews,
    required this.eventIds, // Initialize the new field
  });

  VenueEntity toEntity() {
    return VenueEntity(
      venueId: venueId,
      venuename: venuename,
      picture: picture,
      description: description,
      address: address,
      instagram: instagram,
      website: website,
      reviews: reviews,
      eventIds: eventIds, // Add the new field
    );
  }

  static Venue fromEntity(VenueEntity entity) {
    return Venue(
      venueId: entity.venueId,
      venuename: entity.venuename,
      picture: entity.picture,
      description: entity.description,
      address: entity.address,
      instagram: entity.instagram,
      website: entity.website,
      reviews: entity.reviews,
      eventIds: entity.eventIds, // Add the new field
    );
  }

  // Add an empty constructor
  Venue.empty()
      : venueId = '',
        venuename = '',
        picture = '',
        description = '',
        address = '',
        instagram = '',
        website = '',
        reviews = 0,
        eventIds = [];
}
