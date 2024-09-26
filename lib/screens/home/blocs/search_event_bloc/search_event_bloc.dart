import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:event_repository/event_repository.dart';

import '../get_event_bloc/get_event_bloc.dart';

part 'search_event_event.dart';
part 'search_event_state.dart';

// search_bloc.dart


class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final GetEventBloc getEventBloc;
  late final StreamSubscription getEventBlocSubscription;

  SearchBloc(this.getEventBloc) : super(SearchLoading()) {
    on<SearchQueryChanged>((event, emit) async {
      emit(SearchLoading());
      try {
        final eventState = getEventBloc.state;
        if (eventState is GetEventSuccess) {
          final filteredEvents = eventState.events.where((e) {
            return (e.eventname ?? '').toLowerCase().contains(event.query.toLowerCase());
          }).toList();
          emit(SearchSuccess(filteredEvents));
        } else {
          emit(SearchFailure('Failed to load events'));
        }
      } catch (error) {
        emit(SearchFailure(error.toString()));
      }
    });

    getEventBlocSubscription = getEventBloc.stream.listen((eventState) {
      if (eventState is GetEventSuccess) {
        emit(SearchSuccess(eventState.events));
      } else if (eventState is GetEventFailure) {
        emit(SearchFailure('Failed to load events'));
      }
    });

    _initialize();
  }

  void _initialize() {
    final eventState = getEventBloc.state;
    if (eventState is GetEventSuccess) {
      emit(SearchSuccess(eventState.events));
    }
  }

  @override
  Future<void> close() {
    getEventBlocSubscription.cancel();
    return super.close();
  }
}