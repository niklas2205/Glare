part of 'day_selector_bloc.dart';
abstract class DaySelectorState extends Equatable {
  const DaySelectorState();

  @override
  List<Object> get props => [];
}

class DaySelectorInitial extends DaySelectorState {}

class DaySelected extends DaySelectorState {
  final DateTime selectedDate;

  const DaySelected(this.selectedDate);

  @override
  List<Object> get props => [selectedDate];
}
