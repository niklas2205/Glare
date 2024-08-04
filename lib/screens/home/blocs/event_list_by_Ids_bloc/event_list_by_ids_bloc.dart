import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:event_repository/event_repository.dart';
import 'package:user_repository/user_repository.dart';

part 'event_list_by_ids_event.dart';
part 'event_list_by_ids_state.dart';

class EventListByIdsBloc extends Bloc<EventListByIdsEvent, EventListByIdsState> {
  final EventRepo eventRepo;
  final UserRepository userRepository;

  EventListByIdsBloc(this.eventRepo, this.userRepository) : super(EventListByIdsInitial()) {
    on<FetchEventsByIds>(_onFetchEventsByIds);
  }

  void _onFetchEventsByIds(FetchEventsByIds event, Emitter<EventListByIdsState> emit) async {
    emit(EventListByIdsLoading());
    try {
      final events = await eventRepo.getEventsByIds(event.eventIds);
      final now = DateTime.now().subtract(const Duration(hours: 12));
      final futureEvents = events.where((e) => e.date.isAfter(now)).toList();
      
      final likedEvents = <String>{};
      final likesCount = <String, int>{};

      final user = await userRepository.getCurrentUser();
      if (user != null) {
        for (var event in futureEvents) {
          final count = await eventRepo.getEventLikesCount(event.eventId);
          likesCount[event.eventId] = count;

          final isLiked = await eventRepo.isEventLikedByUser(event.eventId, user.userId);
          if (isLiked) {
            likedEvents.add(event.eventId);
          }
        }
      }

      emit(EventListByIdsLoaded(futureEvents, likedEvents, likesCount));
    } catch (error) {
      emit(EventListByIdsError(error.toString()));
    }
  }
}
