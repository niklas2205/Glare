class VenueEntity {
  String venueId;
  String venuename;
  String picture;
  String description;
  String address;
  String instagram;
  String website;
  int reviews;
  List<String> eventIds;
  List<String> genres;
  final int? prio; // Add Prio field to entity

  VenueEntity({
    required this.venueId,
    required this.venuename,
    required this.picture,
    required this.description,
    required this.address,
    required this.instagram,
    required this.website,
    required this.reviews,
    required this.eventIds,
    required this.genres,
    this.prio, // Add the new field
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
      'reviews': reviews,
      'eventIds': eventIds,
      'genres': genres,
      'prio': prio, // Include the new field in the document map
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
      reviews: doc['reviews'] ?? 0,
      eventIds: _convertToList(doc['eventIds']),
      genres: _convertToList(doc['genres']),
      prio: doc['prio'] ?? 0, // Fetch prio field
    );
  }

  static List<String> _convertToList(dynamic data) {
    if (data is List) {
      return data.map((e) => e.toString()).toList();
    } else if (data is String) {
      return [data];
    } else {
      return [];
    }
  }
}
