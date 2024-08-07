

import 'package:venue_repository/venue_repository.dart';

abstract class VenueRepo {
  Future<List<Venue>> getVenue();
  Future<void> updateVenueImpressions(String venueId, int count); // Add this line
}