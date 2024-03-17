part of 'get_venue_bloc.dart';

sealed class GetVenueEvent extends Equatable {
  const GetVenueEvent();

  @override
  List<Object> get props => [];
}

class GetVenue extends GetVenueEvent{}