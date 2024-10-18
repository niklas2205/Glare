import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:developer';
import '../user_repository.dart';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:developer';
import '../user_repository.dart';
import 'models/models.dart';  

// Ensure you have the correct imports for your user models
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
      // Convert DateTime fields to Timestamp
      Map<String, dynamic> processedData = userData.map((key, value) {
        if (value is DateTime) {
          return MapEntry(key, Timestamp.fromDate(value));
        } else {
          return MapEntry(key, value);
        }
      });
      await usersCollection.doc(currentUser.uid).update(processedData);
    } catch (e) {
      log('Error updating user data: ${e.toString()}');
      rethrow; // Or handle more gracefully
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
      } else {
        // For anonymous users, you might want to create a default MyUser
        MyUser myUser = MyUser(
          userId: firebaseUser.uid,
          email: null,
          name: 'Guest',
          // Initialize other fields as needed
        );
        // Optionally save this data to Firestore
        await setUserData(myUser);
        return myUser;
      }
    }
    return null;
  }

  @override
  Future<MyUser> signUp(MyUser myUser, String password) async {
    try {
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: myUser.email!,
        password: password,
      );
      myUser.userId = user.user!.uid; // Ensure you update the user ID after successful sign-up
      await setUserData(myUser); // Save user data after signing up
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
      await usersCollection.doc(myUser.userId).set(myUser.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<String>> fetchFavoriteVenueIds(String userId) async {
    var snapshot = await usersCollection
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
      rethrow; // Or handle more gracefully
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
    final userDoc = await usersCollection.doc(userId).get();
    if (userDoc.exists) {
      List<dynamic> likedEvents = userDoc.data()?['likedEvents'] ?? [];
      return likedEvents.contains(eventId);
    }
    return false;
  }

  @override
Future<List<String>> getLikedEvents(String userId) async {
  final userDoc = await usersCollection.doc(userId).get();
  if (userDoc.exists) {
    List<dynamic> likedEvents = userDoc.data()?['likedEvents'] ?? [];
    // Filter out any null or empty eventIds
    List<String> validLikedEvents = likedEvents
        .where((id) => id != null && id.toString().isNotEmpty)
        .map((id) => id.toString())
        .toList();
    return validLikedEvents;
  }
  return [];
}

  // Friend request and friends management methods

  @override
  Future<void> sendFriendRequest(String userId, String friendId) async {
    final friendRef = _firestore.collection('users').doc(friendId);

    await friendRef.update({
      'friendRequests': FieldValue.arrayUnion([userId])
    });
  }

  @override
  Future<void> acceptFriendRequest(String userId, String friendId) async {
    final userRef = _firestore.collection('users').doc(userId);
    final friendRef = _firestore.collection('users').doc(friendId);

    await userRef.update({
      'friends': FieldValue.arrayUnion([friendId]),
      'friendRequests': FieldValue.arrayRemove([friendId])
    });

    await friendRef.update({
      'friends': FieldValue.arrayUnion([userId])
    });
  }

  @override
  Future<void> rejectFriendRequest(String userId, String friendId) async {
    final userRef = _firestore.collection('users').doc(userId);

    await userRef.update({
      'friendRequests': FieldValue.arrayRemove([friendId])
    });
  }

  @override
  Future<List<MyUser>> searchUsers(String query) async {
    final snapshot = await _firestore.collection('users')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: '$query\uf8ff')
        .get();

    return snapshot.docs
        .map((doc) => MyUser.fromEntity(MyUserEntity.fromDocument(doc.data())))
        .toList();
  }

  @override
  Stream<List<MyUser>> getFriends(String userId) {
    return usersCollection.doc(userId).snapshots().asyncMap((doc) async {
      final List<dynamic> friendsIds = doc['friends'] ?? [];
      final List<MyUser> friends = [];

      for (final friendId in friendsIds) {
        final friendDoc = await usersCollection.doc(friendId).get();
        if (friendDoc.exists) {
          friends.add(MyUser.fromEntity(MyUserEntity.fromDocument(friendDoc.data()!)));
        }
      }

      return friends;
    });
  }

  @override
  Stream<List<MyUser>> getFriendRequests(String userId) {
    return usersCollection.doc(userId).snapshots().asyncMap((doc) async {
      List<dynamic> requestIds = List<dynamic>.from(doc['friendRequests'] ?? []);
      List<MyUser> requests = [];

      for (final requestId in requestIds) {
        final requestDoc = await usersCollection.doc(requestId).get();
        if (requestDoc.exists) {
          requests.add(MyUser.fromEntity(MyUserEntity.fromDocument(requestDoc.data()!)));
        }
      }

      return requests;
    });
  }

  @override
  Future<List<MyUser>> getFirstUsers(int limit) async {
    final snapshot = await usersCollection
        .orderBy('name')
        .limit(limit)
        .get();

    return snapshot.docs
        .map((doc) => MyUser.fromEntity(MyUserEntity.fromDocument(doc.data())))
        .toList();
  }

  // Getter for current user
  @override
  MyUser? get currentUser {
    var firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser != null) {
      // This assumes the MyUser class can be created from FirebaseUser data
      return MyUser(
        userId: firebaseUser.uid,
        email: firebaseUser.email!,
      );
    }
    return null;
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // The user canceled the sign-in
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase
      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      // Check if the user is new
      bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

      if (isNewUser) {
        // Create a new MyUser object
        MyUser myUser = MyUser(
          userId: userCredential.user!.uid,
          email: userCredential.user!.email ?? '',
          name: userCredential.user!.displayName ?? '',
          dateOfBirth: null, // To be set during onboarding
          favoriteGenres: [], // To be set during onboarding
        );

        // Save user data to Firestore
        await setUserData(myUser);
      }
    } catch (e) {
      log('Error signing in with Google: ${e.toString()}');
      rethrow;
    }
  }
  @override
Future<void> deleteAccount() async {
  try {
    User? user = _firebaseAuth.currentUser;

    if (user != null) {
      // Delete user data from Firestore
      await usersCollection.doc(user.uid).delete();

      // Delete user from Firebase Authentication
      await user.delete();

      // Sign out the user
      await _firebaseAuth.signOut();
    } else {
      throw Exception('No user signed in');
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'requires-recent-login') {
      // Handle re-authentication
      throw FirebaseAuthException(
        code: 'requires-recent-login',
        message: 'User needs to re-authenticate',
      );
    } else {
      log('Error deleting account: ${e.toString()}');
      rethrow;
    }
  } catch (e) {
    log('Error deleting account: ${e.toString()}');
    rethrow;
  }
}


  @override
  Future<void> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Sign in with Firebase
      UserCredential userCredential = await _firebaseAuth.signInWithCredential(oauthCredential);

      // Check if the user is new
      bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

      if (isNewUser) {
        // Create a new MyUser object
        MyUser myUser = MyUser(
          userId: userCredential.user!.uid,
          email: userCredential.user!.email ?? '',
          name: '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'.trim(),
          dateOfBirth: null, // To be set during onboarding
          favoriteGenres: [], // To be set during onboarding
        );

        // Save user data to Firestore
        await setUserData(myUser);
      }
    } catch (e) {
      log('Error signing in with Apple: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> signInAnonymously() async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInAnonymously();
      // Optionally, you can create a MyUser instance and set user data
      MyUser myUser = MyUser(
        userId: userCredential.user!.uid,
        email: null, // Anonymous users don't have an email
        name: 'Guest',
        // Initialize other fields as needed
      );
      await setUserData(myUser);
    } catch (e) {
      log('Error signing in anonymously: ${e.toString()}');
      rethrow;
    }
  }
}