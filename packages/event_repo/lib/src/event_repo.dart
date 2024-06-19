

import 'package:event_repository/event_repository.dart';

abstract class EventRepo {
  Future<void> addEvent(Event event);
  Future<List<Event>> getEvents();  // Ensure this method is defined correctly
}