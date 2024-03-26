part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadUserData extends UserEvent {}

class UpdateFavoriteVenues extends UserEvent {
  final List<String> favoriteVenueIds;

  UpdateFavoriteVenues(this.favoriteVenueIds);

  @override
  List<Object> get props => [favoriteVenueIds];
}