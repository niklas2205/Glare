part of 'get_venue_bloc.dart';

sealed class GetVenueState extends Equatable {
  const GetVenueState();
  
  @override
  List<Object> get props => [];
}


final class GetVenueInitial extends GetVenueState {}

final class GetVenueFailure extends GetVenueState {}
final class GetVenueLoading extends GetVenueState {}
final class GetVenueSuccess extends GetVenueState {
  final List<Venue> venues;

  const GetVenueSuccess(this.venues);

  @override
  List<Object> get props => [venues];

}
