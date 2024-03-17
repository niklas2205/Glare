import 'dart:developer';


import 'package:cloud_firestore/cloud_firestore.dart';

import '../venue_repository.dart';

class FirebaseVenueRepo implements VenueRepo{
  final venueCollection = FirebaseFirestore.instance.collection('venues');

  Future<List<Venue>> getVenue() async{
    try{
      return await venueCollection
        .get()
        .then((value) => value.docs.map((e) =>
          Venue.fromEntity(VenueEntity.fromDocument(e.data()))
        ).toList());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }


}