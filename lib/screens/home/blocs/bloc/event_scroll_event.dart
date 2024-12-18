part of 'event_scroll_bloc.dart';

class EventScrollEvent extends Equatable {
  final double offset;
  EventScrollEvent(this.offset);

  @override
  List<Object?> get props => [offset];
}
