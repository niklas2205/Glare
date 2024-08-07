


import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:venue_repository/venue_repository.dart';


part 'venue_impressions_event.dart';
part 'venue_impressions_state.dart';

class VenueImpressionBloc extends Bloc<VenueImpressionEvent, VenueImpressionState> {
  final VenueRepo venueRepo;
  Map<String, int> localImpressions = {};

  VenueImpressionBloc({required this.venueRepo}) : super(VenueImpressionInitial()) {
    on<IncrementVenueImpression>(_onIncrementVenueImpression);
    on<SyncVenueImpressions>(_onSyncVenueImpressions);
    _startPeriodicSync();
  }

  void _startPeriodicSync() {
    Timer.periodic(Duration(minutes: 120), (timer) {
      add(SyncVenueImpressions());
    });
  }

  Future<void> _onIncrementVenueImpression(
    IncrementVenueImpression event,
    Emitter<VenueImpressionState> emit,
  ) async {
    localImpressions[event.venueId] = (localImpressions[event.venueId] ?? 0) + 1;
    emit(VenueImpressionUpdated(localImpressions[event.venueId]!));
  }

  Future<void> _onSyncVenueImpressions(
    SyncVenueImpressions event,
    Emitter<VenueImpressionState> emit,
  ) async {
    try {
      for (var entry in localImpressions.entries) {
        await venueRepo.updateVenueImpressions(entry.key, entry.value);
      }
      localImpressions.clear();
      emit(VenueImpressionSyncSuccess());
    } catch (e) {
      print('Error syncing venue impressions: $e');
      emit(VenueImpressionFailure(e.toString()));
    }
  }
}
