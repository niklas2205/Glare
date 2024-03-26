

import 'package:equatable/equatable.dart';

enum HomeScreenView { events, venues }

class HomeScreenState extends Equatable {
  final HomeScreenView view;

  const HomeScreenState(this.view);

  @override
  List<Object> get props => [view]; // Ensures Bloc can compare states efficiently.
}

