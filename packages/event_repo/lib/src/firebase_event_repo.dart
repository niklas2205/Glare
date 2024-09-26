

import 'dart:developer';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_repository/event_repository.dart';

class FirebaseEventRepo implements EventRepo {
  final eventCollection = FirebaseFirestore.instance.collection('events');

  @override
  Future<void> addEvent(Event event) async {
    try {
      final eventEntity = event.toEntity();
      await eventCollection.add(eventEntity.toDocument());
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Event>> getEvents() async {
    try {
      return await eventCollection
          .get()
          .then((value) => value.docs
              .map((e) => Event.fromEntity(EventEntity.fromDocument(e.data())))
              .toList());
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> likeEvent(String eventId, String userId) async {
    final eventRef = eventCollection.doc(eventId);
    final eventDoc = await eventRef.get();

    if (eventDoc.exists) {
      await eventRef.update({
        'likedBy': FieldValue.arrayUnion([userId])
      });
    } else {
      throw Exception("Event does not exist.");
    }
  }

  @override
  Future<void> unlikeEvent(String eventId, String userId) async {
    final eventRef = eventCollection.doc(eventId);
    final eventDoc = await eventRef.get();

    if (eventDoc.exists) {
      await eventRef.update({
        'likedBy': FieldValue.arrayRemove([userId])
      });
    } else {
      throw Exception("Event does not exist.");
    }
  }

  @override
  Future<int> getEventLikesCount(String eventId) async {
    final eventDoc = await eventCollection.doc(eventId).get();
    if (eventDoc.exists) {
      List likedBy = eventDoc.data()?['likedBy'] ?? [];
      return likedBy.length;
    }
    return 0;
  }

  @override
  Future<List<Event>> getEventsByIds(List<String> eventIds) async {
    try {
      return await eventCollection
          .where(FieldPath.documentId, whereIn: eventIds)
          .get()
          .then((value) => value.docs
              .map((e) => Event.fromEntity(EventEntity.fromDocument(e.data())))
              .toList());
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<bool> isEventLikedByUser(String eventId, String userId) async {
    final eventDoc = await eventCollection.doc(eventId).get();
    if (eventDoc.exists) {
      List likedBy = eventDoc.data()?['likedBy'] ?? [];
      return likedBy.contains(userId);
    }
    return false;
  }

  @override
  Future<List<Event>> getFutureEvents() async {
    try {
      final DateTime now = DateTime.now().subtract(Duration(hours: 12));
      return await eventCollection
          .get()
          .then((value) => value.docs
              .map((e) => Event.fromEntity(EventEntity.fromDocument(e.data())))
              .where((event) => event.date != null && event.date!.isAfter(now))
              .toList());
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }


  // New method to reload events
  Future<void> reloadEvents() async {
    await getFutureEvents();
  }
}
