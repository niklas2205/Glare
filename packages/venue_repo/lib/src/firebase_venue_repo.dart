import 'dart:developer';


import 'package:cloud_firestore/cloud_firestore.dart';

import '../venue_repository.dart';

class FirebaseVenueRepo implements VenueRepo {
  final venueCollection = FirebaseFirestore.instance.collection('venues');

  @override
  Future<List<Venue>> getVenue() async {
    try {
      final querySnapshot = await venueCollection.get();
      return querySnapshot.docs.map((doc) => Venue.fromEntity(VenueEntity.fromDocument(doc.data()!))).toList();
    } catch (e) {
      print('Error getting venues: $e');
      rethrow;
    }
  }
}