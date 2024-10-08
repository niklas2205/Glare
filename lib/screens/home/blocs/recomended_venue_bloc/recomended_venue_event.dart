part of 'recomended_venue_bloc.dart';



// Define the different events for the RecommendedVenuesBloc
abstract class RecommendedVenuesEvent extends Equatable {
  const RecommendedVenuesEvent();

  @override
  List<Object?> get props => [];
}

// This event will trigger the fetching of recommended venues
class FetchRecommendedVenues extends RecommendedVenuesEvent {
  const FetchRecommendedVenues();
}
