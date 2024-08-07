part of 'venue_impressions_bloc.dart';

abstract class VenueImpressionState {}

class VenueImpressionInitial extends VenueImpressionState {}

class VenueImpressionUpdated extends VenueImpressionState {
  final int count;

  VenueImpressionUpdated(this.count);
}

class VenueImpressionSyncSuccess extends VenueImpressionState {}

class VenueImpressionFailure extends VenueImpressionState {
  final String error;

  VenueImpressionFailure(this.error);
}