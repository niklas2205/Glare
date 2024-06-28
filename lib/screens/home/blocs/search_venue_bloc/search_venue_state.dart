part of 'search_venue_bloc.dart';

abstract class VenueSearchState extends Equatable {
  const VenueSearchState();

  @override
  List<Object> get props => [];
}

class VenueSearchInitial extends VenueSearchState {}

class VenueSearchLoading extends VenueSearchState {}

class VenueSearchSuccess extends VenueSearchState {
  final List<Venue> venues;

  const VenueSearchSuccess(this.venues);

  @override
  List<Object> get props => [venues];
}

class VenueSearchFailure extends VenueSearchState {
  final String error;

  const VenueSearchFailure(this.error);

  @override
  List<Object> get props => [error];
}