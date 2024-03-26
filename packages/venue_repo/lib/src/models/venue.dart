

import '../entities/venue_entities.dart';

class Venue{
  String venueId;
  String venuename;
  String picture;
  String description;
  String address;
  String instagram;
  String website;
  


  Venue({
    required this.venueId,
    required this.venuename,
    required this.picture,
    required this.description,
    required this.address,
    required this.instagram, // Added initializer for the 'Instagram' field
    required this.website, // Added initializer for the 'Website' field
  });


  VenueEntity toEntity() {
    return VenueEntity(
      venueId: venueId,
      venuename: venuename,
      picture: picture,
      description: description,
      address: address,
      instagram: instagram, // Added initializer for the 'Instagram' field
      website: website, // Added initializer for the 'Website' field
    );
  }

  static Venue fromEntity(VenueEntity entity) {
    return Venue(
      venueId: entity.venueId,
      venuename: entity.venuename,
      picture: entity.picture,
      description: entity.description,
      address: entity.address,
      instagram: entity.instagram, // Added initializer for the 'Instagram' field
      website: entity.website, // Added initializer for the 'Website' field
    );
  }
}