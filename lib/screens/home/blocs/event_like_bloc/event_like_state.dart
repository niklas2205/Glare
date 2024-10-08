part of 'event_like_bloc.dart';



abstract class EventLikeState extends Equatable {
  const EventLikeState();

  @override
  List<Object> get props => [];
}

class EventLikeInitial extends EventLikeState {}

class EventLikeLoading extends EventLikeState {}

class EventLikeSuccess extends EventLikeState {
  final List<String> likedEvents;
  final Map<String, int> likesCount;

  const EventLikeSuccess(this.likedEvents, this.likesCount);

  EventLikeSuccess copyWith({
    List<String>? likedEvents,
    Map<String, int>? likesCount,
  }) {
    return EventLikeSuccess(
      likedEvents ?? this.likedEvents,
      likesCount ?? this.likesCount,
    );
  }

  @override
  List<Object> get props => [likedEvents, likesCount];
}


class EventLikeFailure extends EventLikeState {
  final String error;

  const EventLikeFailure(this.error);

  @override
  List<Object> get props => [error];
}