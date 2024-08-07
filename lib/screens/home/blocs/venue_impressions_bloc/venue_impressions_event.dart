part of 'venue_impressions_bloc.dart';

abstract class VenueImpressionEvent {}

class IncrementVenueImpression extends VenueImpressionEvent {
  final String venueId;

  IncrementVenueImpression(this.venueId);
}

class SyncVenueImpressions extends VenueImpressionEvent {}
