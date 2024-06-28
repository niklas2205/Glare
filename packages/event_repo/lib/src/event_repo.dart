

import 'package:event_repository/event_repository.dart';

abstract class EventRepo {
  Future<void> addEvent(Event event);
  Future<List<Event>> getEvents();
  Future<void> likeEvent(String eventId, String userId);
  Future<void> unlikeEvent(String eventId, String userId);
  Future<int> getEventLikesCount(String eventId); 
}