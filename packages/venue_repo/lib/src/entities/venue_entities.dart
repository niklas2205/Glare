class VenueEntity {
  String venueId;
  String venuename;
  String picture;
  String description;
  String address;
  String instagram;
  String website;
  int reviews; // Added reviews field

  VenueEntity({
    required this.venueId,
    required this.venuename,
    required this.picture,
    required this.description,
    required this.address,
    required this.instagram,
    required this.website,
    required this.reviews, // Initialize the reviews field
  });

  Map<String, Object?> toDocument() {
    return {
      'venueId': venueId,
      'venuename': venuename,
      'picture': picture,
      'description': description,
      'address': address,
      'instagram': instagram,
      'website': website,
      'reviews': reviews, // Add reviews field
    };
  }

  static VenueEntity fromDocument(Map<String, dynamic> doc) {
    return VenueEntity(
      venueId: doc['venueId'] ?? '',
      venuename: doc['venuename'] ?? '',
      picture: doc['picture'] ?? '',
      description: doc['description'] ?? '',
      address: doc['address'] ?? '',
      instagram: doc['instagram'] ?? '',
      website: doc['website'] ?? '',
      reviews: doc['reviews'] ?? 0, // Add reviews field
    );
  }
}
