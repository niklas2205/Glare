part of 'day_selector_bloc.dart';

abstract class DaySelectorEvent extends Equatable {
  const DaySelectorEvent();

  @override
  List<Object> get props => [];
}

class SelectDay extends DaySelectorEvent {
  final DateTime selectedDate;

  const SelectDay(this.selectedDate);

  @override
  List<Object> get props => [selectedDate];
}