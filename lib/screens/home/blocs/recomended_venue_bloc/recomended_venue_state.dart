part of 'recomended_venue_bloc.dart';

abstract class RecommendedVenuesState extends Equatable {
  const RecommendedVenuesState();

  @override
  List<Object?> get props => [];
}

// Initial state when the Bloc is first created
class RecommendedVenuesInitial extends RecommendedVenuesState {}

// State when the venues are being loaded
class RecommendedVenuesLoading extends RecommendedVenuesState {}

// State when the venues are successfully loaded
class RecommendedVenuesLoaded extends RecommendedVenuesState {
  final List<Venue> venues;

  const RecommendedVenuesLoaded({required this.venues});

  @override
  List<Object?> get props => [venues];
}

// State when there are no recommended venues to show
class RecommendedVenuesEmpty extends RecommendedVenuesState {}

// State when there's an error loading the venues
class RecommendedVenuesError extends RecommendedVenuesState {
  final String message;

  const RecommendedVenuesError(this.message);

  @override
  List<Object?> get props => [message];
}