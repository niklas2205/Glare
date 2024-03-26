
import 'home_screen_state.dart';

abstract class HomeScreenEvent {}

class ToggleViewEvent extends HomeScreenEvent {
  final HomeScreenView view;
  ToggleViewEvent(this.view);
}