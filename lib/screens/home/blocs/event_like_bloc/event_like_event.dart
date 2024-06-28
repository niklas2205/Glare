part of 'event_like_bloc.dart';

// event_like_event.dart


abstract class EventLikeEvent extends Equatable {
  const EventLikeEvent();

  @override
  List<Object> get props => [];
}

class LikeEvent extends EventLikeEvent {
  final String userId;
  final String eventId;

  const LikeEvent({required this.userId, required this.eventId});

  @override
  List<Object> get props => [userId, eventId];
}

class UnlikeEvent extends EventLikeEvent {
  final String userId;
  final String eventId;

  const UnlikeEvent({required this.userId, required this.eventId});

  @override
  List<Object> get props => [userId, eventId];
}

class LoadLikedEvents extends EventLikeEvent {
  final String userId;

  const LoadLikedEvents(this.userId);

  @override
  List<Object> get props => [userId];
}

class LoadEventLikeCount extends EventLikeEvent {
  final String eventId;

  const LoadEventLikeCount(this.eventId);

  @override
  List<Object> get props => [eventId];
}