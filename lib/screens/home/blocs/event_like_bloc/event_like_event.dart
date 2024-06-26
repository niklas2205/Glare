part of 'event_like_bloc.dart';

abstract class EventLikeEvent extends Equatable {
  const EventLikeEvent();
}

class LikeEvent extends EventLikeEvent {
  final String userId;
  final String eventId;

  const LikeEvent({required this.userId, required this.eventId});

  @override
  List<Object?> get props => [userId, eventId];
}