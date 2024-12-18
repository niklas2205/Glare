part of 'event_scroll_bloc.dart';

class EventScrollState extends Equatable {
  final DateTime? visibleDate;

  const EventScrollState({this.visibleDate});

  EventScrollState copyWith({DateTime? visibleDate}) {
    return EventScrollState(visibleDate: visibleDate);
  }

  @override
  List<Object?> get props => [visibleDate];
}