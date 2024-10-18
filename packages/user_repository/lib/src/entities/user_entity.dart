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

 static MyUserEntity fromDocument(DocumentSnapshot doc) {
  final data = doc.data() as Map<String, dynamic>;
  return MyUserEntity(
    userId: data['userId'] ?? doc.id,
    email: data['email'] ?? '',
    name: data['name'],
    dateOfBirth: data['dateOfBirth'] != null
        ? (data['dateOfBirth'] as Timestamp).toDate()
        : null,
    favoriteGenres: List<String>.from(data['favoriteGenres'] ?? []),
    phoneNumber: data['phoneNumber'],
    gender: data['gender'],
    friendRequests: List<String>.from(data['friendRequests'] ?? []),
    friends: List<String>.from(data['friends'] ?? []),
  );
}


}
