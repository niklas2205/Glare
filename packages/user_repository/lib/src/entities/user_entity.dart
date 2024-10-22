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
  // Ensure data['userId'] is not null and not empty
  final userId = (data['userId'] != null && (data['userId'] as String).isNotEmpty)
      ? data['userId'] as String
      : doc.id;

  return MyUserEntity(
    userId: userId,
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
