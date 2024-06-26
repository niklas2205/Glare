part of 'event_like_bloc.dart';

abstract class EventLikeState extends Equatable {
  const EventLikeState();

  @override
  List<Object?> get props => [];
}

class EventLikeInitial extends EventLikeState {}

class EventLikeLoading extends EventLikeState {}

class EventLikeSuccess extends EventLikeState {}

class EventLikeFailure extends EventLikeState {
  final String error;

  const EventLikeFailure(this.error);

  @override
  List<Object?> get props => [error];
}