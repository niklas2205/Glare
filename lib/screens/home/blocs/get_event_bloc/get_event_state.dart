part of 'get_event_bloc.dart';

sealed class GetEventState extends Equatable {
  const GetEventState();
  
  @override
  List<Object> get props => [];
}

final class GetEventInitial extends GetEventState {}

final class GetEventFailure extends GetEventState {}
final class GetEventLoading extends GetEventState {}
final class GetEventSuccess extends GetEventState {
  final List<Event> events;

  const GetEventSuccess(this.events);

  @override
  List<Object> get props => [events];

}

