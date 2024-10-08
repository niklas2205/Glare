import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:glare/screens/home/blocs/user_bloc/user_bloc.dart';
import 'package:venue_repository/venue_repository.dart';

part 'recomended_venue_event.dart';
part 'recomended_venue_state.dart';

class RecommendedVenuesBloc extends Bloc<RecommendedVenuesEvent, RecommendedVenuesState> {
  final VenueRepo venueRepo;
  final UserBloc userBloc;

  RecommendedVenuesBloc({
    required this.venueRepo,
    required this.userBloc,
  }) : super(RecommendedVenuesInitial()) {
    on<FetchRecommendedVenues>(_onFetchRecommendedVenues);
  }

  Future<void> _onFetchRecommendedVenues(
      FetchRecommendedVenues event, Emitter<RecommendedVenuesState> emit) async {
    emit(RecommendedVenuesLoading());

    try {
      // Fetch all venues from the repository
      final venues = await venueRepo.getVenues();

      // Fetch the current user's genres and favorite venues from the UserBloc
      final userState = userBloc.state;
      List<String> userGenres = [];
      List<String> favoriteVenues = [];
      if (userState is UserLoaded) {
        userGenres = userState.user.favoriteGenres ?? [];
        favoriteVenues = userState.favoriteVenueIds ?? [];
      }

      print("User genres: $userGenres");
      print("Favorite venues for user: $favoriteVenues");

      // Calculate the score for each venue
      final venuesWithScores = venues.map((venue) {
        int score = _calculateVenueScore(venue, userGenres, favoriteVenues);
        print('Venue ${venue.venueId} score: $score'); // Print the score for each venue
        return {'venue': venue, 'score': score};
      }).toList();

      // Sort the venues based on their score in descending order
      venuesWithScores.sort((a, b) {
        int scoreA = a['score'] as int? ?? 0;
        int scoreB = b['score'] as int? ?? 0;
        return scoreB.compareTo(scoreA);
      });

      // Limit the sorted venues to the top 6 and cast them to Venue
      final topVenues = venuesWithScores
          .take(6)
          .map((e) => e['venue'] as Venue)
          .toList();

      // If no venues are found, emit an empty state
      if (topVenues.isEmpty) {
        emit(RecommendedVenuesEmpty());
      } else {
        emit(RecommendedVenuesLoaded(venues: topVenues));
        print("Top venues loaded: ${topVenues.map((venue) => venue.venueId).toList()}");
      }
    } catch (e) {
      emit(RecommendedVenuesError('Failed to load recommended venues'));
      print('Error loading recommended venues: $e');
    }
  }

  // A function to calculate the score for each venue based on user preferences
  int _calculateVenueScore(Venue venue, List<String> userGenres, List<String> favoriteVenues) {
  int score = 0;

  // Increase score if the venue matches any of the user's genres
  for (var genre in venue.genres) {
    if (userGenres.contains(genre)) {
      score += 10;
    }
  }

  // Increase score if the venue is favorited by the user
  if (favoriteVenues.contains(venue.venueId)) {
    score += 5;
  }

  // Adjust the score based on venue priority
  if (venue.prio == 1) {
    score += 10;
  } else if (venue.prio == 2) {
    score += 5;
  } else if (venue.prio == 3) {
    score += 0;
  }

  return score;
}
}
