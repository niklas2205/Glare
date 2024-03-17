

import 'package:event_repository/event_repository.dart';

abstract class EventRepo{
    Future<List<Event>> getEvent();

}