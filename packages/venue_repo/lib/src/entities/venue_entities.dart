class VenueEntity {
  String venueId;
  String venuename;
  String picture;
  String description;
  String address;
  String instagram;
  String website;
  

  VenueEntity({
    required this.venueId,
    required this.venuename,
    required this.picture,
    required this.description,
    required this.address,
    required this.instagram, // Added initializer for the 'Instagram' field
    required this.website, // Added initializer for the 'Website' field
  });

  Map<String, Object?> toDocument() {
    return {
      'eventId':  venueId,
      'eventname':  venuename,
      'picture':  picture,
      'description':  description,
      'address':  address,
      'instagram':  instagram, // Added initializer for the 'Instagram' field
      'website':  website, // Added initializer for the 'Website' field
    };
  }

  static VenueEntity fromDocument(Map<String, dynamic> doc) {
    return VenueEntity(
      venueId: doc['venueId'] ?? 'Default Venue ID',
      venuename: doc['venuename'] ?? 'Default Venue Name',
      picture: doc['picture'] ?? 'Default Picture URL',
      description: doc['description'] ?? 'Default Description',
      address: doc['address'] ?? 'Default Address',
      instagram: doc['instagram'] ?? 'Default Instagram',
      website: doc['website'] ?? 'Default Website',
    );
  }
}