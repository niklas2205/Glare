part of 'get_venue_bloc.dart';


abstract class GetVenueEvent extends Equatable {
  const GetVenueEvent();

  @override
  List<Object> get props => [];
}

class GetVenue extends GetVenueEvent {}
