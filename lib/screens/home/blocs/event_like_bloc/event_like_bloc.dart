import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:event_repository/event_repository.dart';
import 'package:user_repository/user_repository.dart';

part 'event_like_event.dart';
part 'event_like_state.dart';

class EventLikeBloc extends Bloc<EventLikeEvent, EventLikeState> {
  final UserRepository userRepository;
  final EventRepo eventRepository;
  Timer? _periodicSync;

  EventLikeBloc({
    required this.userRepository,
    required this.eventRepository,
  }) : super(EventLikeInitial()) {
    on<LikeEvent>(_onLikeEvent);
    on<UnlikeEvent>(_onUnlikeEvent);
    on<LoadLikedEvents>(_onLoadLikedEvents);
    on<LoadEventLikeCount>(_onLoadEventLikeCount);

    userRepository.getCurrentUser().then((user) {
      if (user != null) {
        add(LoadLikedEvents(user.userId));
      }
    });

    _startPeriodicSync();
  }

  void _startPeriodicSync() {
    _periodicSync = Timer.periodic(const Duration(minutes: 30), (timer) async {
      final user = await userRepository.getCurrentUser();
      if (user != null) {
        add(LoadLikedEvents(user.userId));
      }
    });
  }

  @override
  Future<void> close() {
    _periodicSync?.cancel();
    return super.close();
  }

  Future<void> _onLikeEvent(LikeEvent event, Emitter<EventLikeState> emit) async {
    try {
      await userRepository.likeEvent(event.userId, event.eventId);
      await eventRepository.likeEvent(event.eventId, event.userId);

      if (state is EventLikeSuccess) {
        final likedEvents = List<String>.from((state as EventLikeSuccess).likedEvents);
        final likesCountMap = Map<String, int>.from((state as EventLikeSuccess).likesCount);

        likedEvents.add(event.eventId);
        likesCountMap[event.eventId] = (likesCountMap[event.eventId] ?? 0) + 1;

        emit(EventLikeSuccess(likedEvents, likesCountMap));
      } else {
        emit(EventLikeSuccess([event.eventId], {event.eventId: 1}));
      }
    } catch (e) {
      emit(EventLikeFailure(e.toString()));
    }
  }

  Future<void> _onUnlikeEvent(UnlikeEvent event, Emitter<EventLikeState> emit) async {
    try {
      await userRepository.unlikeEvent(event.userId, event.eventId);
      await eventRepository.unlikeEvent(event.eventId, event.userId);

      if (state is EventLikeSuccess) {
        final likedEvents = List<String>.from((state as EventLikeSuccess).likedEvents);
        final likesCountMap = Map<String, int>.from((state as EventLikeSuccess).likesCount);

        likedEvents.remove(event.eventId);
        likesCountMap[event.eventId] = (likesCountMap[event.eventId] ?? 1) - 1;

        emit(EventLikeSuccess(likedEvents, likesCountMap));
      } else {
        emit(EventLikeSuccess([], {event.eventId: 0}));
      }
    } catch (e) {
      emit(EventLikeFailure(e.toString()));
    }
  }

  Future<void> _onLoadLikedEvents(LoadLikedEvents event, Emitter<EventLikeState> emit) async {
    try {
      final likedEvents = await userRepository.getLikedEvents(event.userId);
      final futureEvents = await eventRepository.getFutureEvents();
      final futureEventIds = futureEvents.map((e) => e.eventId).toSet();

      final validLikedEvents = likedEvents.where(futureEventIds.contains).toList();
      final likesCountMap = <String, int>{};

      for (var eventId in validLikedEvents) {
        final count = await eventRepository.getEventLikesCount(eventId);
        likesCountMap[eventId] = count;
      }

      emit(EventLikeSuccess(validLikedEvents, likesCountMap));
    } catch (e) {
      emit(EventLikeFailure(e.toString()));
    }
  }

  Future<void> _onLoadEventLikeCount(LoadEventLikeCount event, Emitter<EventLikeState> emit) async {
    try {
      final likesCount = await eventRepository.getEventLikesCount(event.eventId);
      if (state is EventLikeSuccess) {
        final likedEvents = List<String>.from((state as EventLikeSuccess).likedEvents);
        final likesCountMap = Map<String, int>.from((state as EventLikeSuccess).likesCount);
        likesCountMap[event.eventId] = likesCount;
        emit(EventLikeSuccess(likedEvents, likesCountMap));
      } else {
        emit(EventLikeSuccess([], {event.eventId: likesCount}));
      }
    } catch (e) {
      emit(EventLikeFailure(e.toString()));
    }
  }
}
