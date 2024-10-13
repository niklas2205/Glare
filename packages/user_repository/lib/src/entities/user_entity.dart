import 'package:cloud_firestore/cloud_firestore.dart';

class MyUserEntity {
  String userId;
  String? email;
  String? name;
  DateTime? dateOfBirth; // Changed from int? age to DateTime? dateOfBirth
  List<String>? favoriteGenres;
  String? phoneNumber;
  String? gender;
  List<String>? friendRequests;
  List<String>? friends;

  MyUserEntity({
    required this.userId,
    this.email,
    this.name,
    this.dateOfBirth,
    this.favoriteGenres,
    this.phoneNumber,
    this.gender,
    this.friendRequests,
    this.friends,
  });

 Map<String, Object?> toDocument() {
  return {
    'userId': userId,
    'email': email,
    'name': name,
    'dateOfBirth': dateOfBirth != null ? Timestamp.fromDate(dateOfBirth!) : null,
    'favoriteGenres': favoriteGenres,
    'phoneNumber': phoneNumber,
    'gender': gender,
    'friendRequests': friendRequests,
    'friends': friends,
  };
}

 static MyUserEntity fromDocument(Map<String, dynamic> doc) {
  return MyUserEntity(
    userId: doc['userId'] ?? '',
    email: doc['email'] ?? '',
    name: doc['name'],
    dateOfBirth: doc['dateOfBirth'] != null
        ? (doc['dateOfBirth'] as Timestamp).toDate()
        : null,
    favoriteGenres: List<String>.from(doc['favoriteGenres'] ?? []),
    phoneNumber: doc['phoneNumber'],
    gender: doc['gender'],
    friendRequests: List<String>.from(doc['friendRequests'] ?? []),
    friends: List<String>.from(doc['friends'] ?? []),
  );
}


}
