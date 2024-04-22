

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addToFavorites(String userId, String venueId) async {
    try {
      print("Firestore - Adding venue $venueId to user $userId favorites");
      await firestore.collection('users').doc(userId).collection('favorite_venues').doc(venueId).set({'favorited': true});
      print("Firestore - Venue added successfully");
    } catch (e) {
      print("Error adding venue to favorites: $e");
    }
  }

  Future<void> removeFromFavorites(String userId, String venueId) async {
    try {
      print("Firestore - Removing venue $venueId from user $userId favorites");
      await firestore.collection('users').doc(userId).collection('favorite_venues').doc(venueId).delete();
      print("Firestore - Venue removed successfully");
    } catch (e) {
      print("Error removing venue from favorites: $e");
    }
  }

  Future<List<String>> fetchUserFavorites(String userId) async {
    try {
      var snapshot = await firestore.collection('users').doc(userId).collection('favorite_venues').get();
      return snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print('Error fetching favorites: $e');
      return [];
    }
  }
}