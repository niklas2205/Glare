part of 'favourite_venue_bloc.dart';
abstract class FavouriteVenueEvent {}

class AddVenueToFavorites extends FavouriteVenueEvent {
  final String venueId;
  final String userId;

  AddVenueToFavorites(this.userId, this.venueId);
}


class RemoveVenueFromFavorites extends FavouriteVenueEvent {
  final String venueId;
  final String userId;

  RemoveVenueFromFavorites(this.userId, this.venueId);
}

class LoadUserFavorites extends FavouriteVenueEvent {
  final String userId;

  LoadUserFavorites(this.userId);
}