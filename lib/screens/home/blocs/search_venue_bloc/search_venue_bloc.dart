import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:venue_repository/venue_repository.dart';

import '../get_venue_bloc/get_venue_bloc.dart';
import '../search_event_bloc/search_event_bloc.dart';

part 'search_venue_event.dart';
part 'search_venue_state.dart';



class VenueSearchBloc extends Bloc<VenueSearchEvent, VenueSearchState> {
  final GetVenueBloc getVenueBloc;
  late final StreamSubscription getVenueBlocSubscription;

  VenueSearchBloc(this.getVenueBloc) : super(VenueSearchLoading()) {
    on<VenueSearchQueryChanged>((event, emit) async {
      emit(VenueSearchLoading());
      try {
        final venueState = getVenueBloc.state;
        if (venueState is GetVenueSuccess) {
          final filteredVenues = venueState.venues.where((v) {
            return v.venuename.toLowerCase().contains(event.query.toLowerCase());
          }).toList();
          emit(VenueSearchSuccess(filteredVenues));
        } else {
          emit(VenueSearchFailure('Failed to load venues'));
        }
      } catch (error) {
        emit(VenueSearchFailure(error.toString()));
      }
    });

    getVenueBlocSubscription = getVenueBloc.stream.listen((venueState) {
      if (venueState is GetVenueSuccess) {
        emit(VenueSearchSuccess(venueState.venues));
      } else if (venueState is GetVenueFailure) {
        emit(VenueSearchFailure('Failed to load venues'));
      }
    });

    _initialize();
  }

  void _initialize() {
    final venueState = getVenueBloc.state;
    if (venueState is GetVenueSuccess) {
      emit(VenueSearchSuccess(venueState.venues));
    }
  }

  @override
  Future<void> close() {
    getVenueBlocSubscription.cancel();
    return super.close();
  }
}
