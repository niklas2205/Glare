part of 'event_list_by_ids_bloc.dart';

abstract class EventListByIdsState extends Equatable {
  const EventListByIdsState();

  @override
  List<Object> get props => [];
}

class EventListByIdsInitial extends EventListByIdsState {}

class EventListByIdsLoading extends EventListByIdsState {}

class EventListByIdsLoaded extends EventListByIdsState {
  final List<Event> events;
  final Set<String> likedEvents;
  final Map<String, int> likesCount;

  const EventListByIdsLoaded(this.events, this.likedEvents, this.likesCount);

  @override
  List<Object> get props => [events, likedEvents, likesCount];
}

class EventListByIdsError extends EventListByIdsState {
  final String error;

  const EventListByIdsError(this.error);

  @override
  List<Object> get props => [error];
}