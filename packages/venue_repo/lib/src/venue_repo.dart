

import 'package:venue_repo/venue_repository.dart';


abstract class VenueRepo{
    Future<List<Venue>> getVenue();

}