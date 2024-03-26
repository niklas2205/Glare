import 'package:firebase_database/firebase_database.dart';

class DatabaseRepository {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref();

  Future<void> addToFavorites(String userId, String venueId) async {
    await dbRef.child('users/$userId/favorite_venues/$venueId').set(true);
  }

  Future<void> removeFromFavorites(String userId, String venueId) async {
    await dbRef.child('users/$userId/favorite_venues/$venueId').remove();
  }

  Future<List<String>> fetchUserFavorites(String userId) async {
    DataSnapshot snapshot = await dbRef.child('users/$userId/favorite_venues').get();
    if (snapshot.exists && snapshot.value != null) {
      Map<dynamic, dynamic> favoritesMap = Map<dynamic, dynamic>.from(snapshot.value as Map);
      return favoritesMap.keys.cast<String>().toList();
    } else {
      return [];
    }
  }
}