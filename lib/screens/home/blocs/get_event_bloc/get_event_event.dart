part of 'get_event_bloc.dart';

sealed class GetEventEvent extends Equatable {
  const GetEventEvent();

  @override
  List<Object> get props => [];
}

final class GetEvent extends GetEventEvent {}