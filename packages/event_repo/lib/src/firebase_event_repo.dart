

import 'dart:developer';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_repository/event_repository.dart';

class FirebaseEventRepo implements EventRepo{
  final eventCollection = FirebaseFirestore.instance.collection('events');

  Future<List<Event>> getEvent() async{
    try{
      return await eventCollection
        .get()
        .then((value) => value.docs.map((e) =>
          Event.fromEntity(EventEntity.fromDocument(e.data()))
        ).toList());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }


}