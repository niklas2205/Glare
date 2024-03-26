part of 'favourite_venue_bloc.dart';

abstract class FavouriteVenueState {}

class FavoritesLoading extends FavouriteVenueState {}

class FavoritesLoaded extends FavouriteVenueState {
  final List<String> favoriteVenueIds;

  FavoritesLoaded(this.favoriteVenueIds);
}

class FavoriteAdded extends FavouriteVenueState {}

class FavoriteRemoved extends FavouriteVenueState {}

class FavoriteActionError extends FavouriteVenueState {}
class FavoritesLoadError extends FavouriteVenueState {}
