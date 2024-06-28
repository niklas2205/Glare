part of 'search_venue_bloc.dart';

abstract class VenueSearchEvent extends Equatable {
  const VenueSearchEvent();

  @override
  List<Object> get props => [];
}

class VenueSearchQueryChanged extends VenueSearchEvent {
  final String query;

  const VenueSearchQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}