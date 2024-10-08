import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:event_repository/event_repository.dart';
import 'package:glare/screens/home/blocs/event_like_bloc/event_like_bloc.dart';

part 'recomended_events_event.dart';
part 'recomended_events_state.dart';


class RecommendedEventsBloc extends Cubit<List<Event>> {
  final EventRepo eventRepo;
  final EventLikeBloc eventLikeBloc;

  RecommendedEventsBloc({
    required this.eventRepo,
    required this.eventLikeBloc,
  }) : super([]);

  Future<void> fetchRecommendedEvents() async {
    try {
      // Fetch all future events
      final events = await eventRepo.getFutureEvents();

      // Fetch the likes data from the EventLikeBloc
      final likesState = eventLikeBloc.state;
      Map<String, int> likesCountMap = {};
      if (likesState is EventLikeSuccess) {
        likesCountMap = likesState.likesCount;
      }

      // Separate prio = 1 events from the rest
      final prioEvents = events.where((event) => event.prio == 1).toList();
      final nonPrioEvents = events.where((event) => event.prio != 1).toList();

      // Sort the non-prio events by likes
      nonPrioEvents.sort((a, b) {
        final likesA = likesCountMap[a.eventId] ?? 0;
        final likesB = likesCountMap[b.eventId] ?? 0;
        return likesB.compareTo(likesA); // Sort by likes in descending order
      });

      // Combine prio events and liked events
      final combinedEvents = prioEvents + nonPrioEvents;

      // Limit the results to 4 recommended events
      emit(combinedEvents.take(4).toList());
    } catch (e) {
      emit([]); // Emit an empty list on error
    }
  }
}
