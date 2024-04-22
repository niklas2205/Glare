import 'package:bloc/bloc.dart';


// home_screen_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_screen_event.dart';
import 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  HomeScreenBloc() : super(const HomeScreenState(HomeScreenView.events)) {
    on<ToggleViewEvent>(_onToggleViewEvent);
  }

  void _onToggleViewEvent(ToggleViewEvent event, Emitter<HomeScreenState> emit) {
    // Handle the ToggleViewEvent
    if (event.view == HomeScreenView.events) {
      // Update the state to show events
      emit(const HomeScreenState(HomeScreenView.events));
    } else if (event.view == HomeScreenView.venues) {
      // Update the state to show venues
      emit(const HomeScreenState(HomeScreenView.venues));
    }
  }
}