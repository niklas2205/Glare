import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:glare/screens/home/blocs/favourite_venue_bloc/favourite_venue_bloc.dart';
import 'package:venue_repository/venue_repository.dart';

import '../get_venue_bloc/get_venue_bloc.dart';
import '../search_event_bloc/search_event_bloc.dart';

part 'search_venue_event.dart';
part 'search_venue_state.dart';



class VenueSearchBloc extends Bloc<VenueSearchEvent, VenueSearchState> {
  final GetVenueBloc getVenueBloc;
  final FavouriteVenueBloc favouriteVenueBloc;
  late final StreamSubscription getVenueBlocSubscription;
  late final StreamSubscription favouriteVenueBlocSubscription;

  List<Venue> allVenues = [];
  List<String> likedVenueIds = [];
  List<String> selectedGenres = [];
  bool filterLikedVenues = false;

  VenueSearchBloc(this.getVenueBloc, this.favouriteVenueBloc) : super(VenueSearchLoading()) {
    on<VenueSearchQueryChanged>((event, emit) async {
      _filterAndEmitResults(event.query, emit);
    });

    on<VenueFilterChanged>((event, emit) async {
      selectedGenres = event.genres;
      filterLikedVenues = event.filterLiked;
      _filterAndEmitResults(event.query, emit);
    });

    getVenueBlocSubscription = getVenueBloc.stream.listen((venueState) {
      if (venueState is GetVenueSuccess) {
        allVenues = venueState.venues;
        add(VenueSearchQueryChanged('')); // Trigger a state update
      } else if (venueState is GetVenueFailure) {
        emit(VenueSearchFailure('Failed to load venues'));
      }
    });

    favouriteVenueBlocSubscription = favouriteVenueBloc.stream.listen((favouriteState) {
      if (favouriteState is FavoritesLoaded) {
        likedVenueIds = favouriteState.favoriteVenueIds;
        add(VenueSearchQueryChanged('')); // Trigger a state update
      }
    });

    _initialize();
  }

  void _initialize() {
    final venueState = getVenueBloc.state;
    final favouriteState = favouriteVenueBloc.state;

    if (venueState is GetVenueSuccess) {
      allVenues = venueState.venues;
    }

    if (favouriteState is FavoritesLoaded) {
      likedVenueIds = favouriteState.favoriteVenueIds;
    }

    if (allVenues.isNotEmpty) {
      emit(VenueSearchSuccess(allVenues));
    }
  }

  void _filterAndEmitResults(String query, Emitter<VenueSearchState> emit) {
    final filteredVenues = allVenues.where((v) {
      final matchesQuery = v.venuename.toLowerCase().contains(query.toLowerCase());
      final matchesGenre = selectedGenres.isEmpty || v.genres.any((genre) => selectedGenres.contains(genre));
      final matchesLiked = !filterLikedVenues || likedVenueIds.contains(v.venueId); // Using `venueId`
      return matchesQuery && matchesGenre && matchesLiked;
    }).toList();
    emit(VenueSearchSuccess(filteredVenues));
  }

  @override
  Future<void> close() {
    getVenueBlocSubscription.cancel();
    favouriteVenueBlocSubscription.cancel();
    return super.close();
  }
}
