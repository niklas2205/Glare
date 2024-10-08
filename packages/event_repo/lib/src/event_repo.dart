

import 'package:event_repository/event_repository.dart';

abstract class EventRepo {
  Future<void> addEvent(Event event);
  Future<List<Event>> getEvents();
  Future<void> likeEvent(String eventId, String userId);
  Future<void> unlikeEvent(String eventId, String userId);
  Future<int> getEventLikesCount(String eventId);
  Future<List<Event>> getEventsByIds(List<String> eventIds);
  Future<bool> isEventLikedByUser(String eventId, String userId);
  Future<List<Event>> getFutureEvents();
}
