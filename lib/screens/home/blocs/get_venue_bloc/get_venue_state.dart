part of 'get_venue_bloc.dart';

abstract class GetVenueState extends Equatable {
  const GetVenueState();

  @override
  List<Object> get props => [];
}

class GetVenueInitial extends GetVenueState {}

class GetVenueLoading extends GetVenueState {}

class GetVenueSuccess extends GetVenueState {
  final List<Venue> venues;

  const GetVenueSuccess(this.venues);

  @override
  List<Object> get props => [venues];
}

class GetVenueFailure extends GetVenueState {}