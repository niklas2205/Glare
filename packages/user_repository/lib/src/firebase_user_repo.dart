import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:developer';
import '../user_repository.dart';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:developer';
import '../user_repository.dart';
import 'models/models.dart';  // Ensure you have the correct imports for your user models

class FirebaseUserRepo implements UserRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final usersCollection = FirebaseFirestore.instance.collection('users');

  FirebaseUserRepo({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> updateUserData(Map<String, dynamic> userData) async {
    var currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) {
      throw Exception("No user signed in.");
    }
    try {
      await usersCollection.doc(currentUser.uid).update(userData);
    } catch (e) {
      log('Error updating user data: ${e.toString()}');
      throw e; // Or handle more gracefully
    }
  }

  @override
  Stream<MyUser?> get user {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) {
        return MyUser.empty;
      } else {
        var doc = await usersCollection.doc(firebaseUser.uid).get();
        return MyUser.fromEntity(MyUserEntity.fromDocument(doc.data()!));
      }
    });
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<MyUser?> getCurrentUser() async {
    var firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser != null) {
      var userDoc = await usersCollection.doc(firebaseUser.uid).get();
      if (userDoc.exists) {
        return MyUser.fromEntity(MyUserEntity.fromDocument(userDoc.data()!));
      }
    }
    return null;
  }

  @override
  Future<MyUser> signUp(MyUser myUser, String password) async {
    try {
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
          email: myUser.email,
          password: password
      );
      myUser.userId = user.user!.uid;  // Ensure you update the user ID after successful sign-up
      await setUserData(myUser);  // Save user data after signing up
      return myUser;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> setUserData(MyUser myUser) async {
    try {
      await usersCollection
          .doc(myUser.userId)
          .set(myUser.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<String>> fetchFavoriteVenueIds(String userId) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorite_venues')
        .get();

    return snapshot.docs.map((doc) => doc.id).toList();
  }

  @override
  Future<void> saveUserGenres(String userId, List<String> genres) async {
    try {
      await usersCollection.doc(userId).update({'favoriteGenres': genres});
    } catch (e) {
      log('Failed to save user genres: ${e.toString()}');
      throw e;  // Or handle more gracefully
    }
  }

  @override
  Future<void> likeEvent(String userId, String eventId) async {
    final userRef = _firestore.collection('users').doc(userId);
    final eventRef = _firestore.collection('events').doc(eventId);

    await userRef.update({
      'likedEvents': FieldValue.arrayUnion([eventId])
    });

    await eventRef.update({
      'likedBy': FieldValue.arrayUnion([userId])
    });
  }

  @override
  Future<void> unlikeEvent(String userId, String eventId) async {
    final userRef = _firestore.collection('users').doc(userId);
    final eventRef = _firestore.collection('events').doc(eventId);

    await userRef.update({
      'likedEvents': FieldValue.arrayRemove([eventId])
    });

    await eventRef.update({
      'likedBy': FieldValue.arrayRemove([userId])
    });
  }

  @override
  Future<bool> isEventLiked(String userId, String eventId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    if (userDoc.exists) {
      List likedEvents = userDoc.data()?['likedEvents'] ?? [];
      return likedEvents.contains(eventId);
    }
    return false;
  }

  @override
  Future<List<String>> getLikedEvents(String userId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    if (userDoc.exists) {
      List likedEvents = userDoc.data()?['likedEvents'] ?? [];
      return List<String>.from(likedEvents);
    }
    return [];
  }
}