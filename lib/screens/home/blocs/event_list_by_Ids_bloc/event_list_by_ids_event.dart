part of 'event_list_by_ids_bloc.dart';

abstract class EventListByIdsEvent extends Equatable {
  const EventListByIdsEvent();

  @override
  List<Object> get props => [];
}

class FetchEventsByIds extends EventListByIdsEvent {
  final List<String> eventIds;

  const FetchEventsByIds(this.eventIds);

  @override
  List<Object> get props => [eventIds];
}