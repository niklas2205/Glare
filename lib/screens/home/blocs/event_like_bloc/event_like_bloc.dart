import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:event_repository/event_repository.dart';
import 'package:user_repository/user_repository.dart';

part 'event_like_event.dart';
part 'event_like_state.dart';

class EventLikeBloc extends Bloc<EventLikeEvent, EventLikeState> {
  final UserRepository userRepository;
  final EventRepo eventRepository;

  EventLikeBloc({
    required this.userRepository,
    required this.eventRepository,
  }) : super(EventLikeInitial()) {
    on<LikeEvent>((event, emit) async {
      emit(EventLikeLoading());
      try {
        await userRepository.likeEvent(event.userId, event.eventId);
        await eventRepository.likeEvent(event.eventId, event.userId);
        emit(EventLikeSuccess());
      } catch (e) {
        emit(EventLikeFailure(e.toString()));
      }
    });
  }
}
