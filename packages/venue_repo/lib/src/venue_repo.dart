

import 'package:venue_repository/venue_repository.dart';

abstract class VenueRepo {
  Future<List<Venue>> getVenue();
}
