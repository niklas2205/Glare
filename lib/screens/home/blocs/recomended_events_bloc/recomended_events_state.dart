part of 'recomended_events_bloc.dart';

sealed class RecomendedEventsState extends Equatable {
  const RecomendedEventsState();
  
  @override
  List<Object> get props => [];
}

final class RecomendedEventsInitial extends RecomendedEventsState {}
