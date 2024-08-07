class MyUserEntity {
  String userId;
  String email;
  String? name;
  DateTime? dob; // Changed from int? age to DateTime? dob
  List<String>? favoriteGenres;
  String? phoneNumber;
  String? gender;
  List<String>? friendRequests;
  List<String>? friends;

  MyUserEntity({
    required this.userId,
    required this.email,
    required this.name,
    required this.dob,
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
      'dob': dob?.toIso8601String(), // Convert DateTime to String
      'favoriteGenres': favoriteGenres,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'friendRequests': friendRequests,
      'friends': friends,
    };
  }

  static MyUserEntity fromDocument(Map<String, dynamic> doc) {
    return MyUserEntity(
      userId: doc['userId'],
      email: doc['email'],
      name: doc['name'],
      dob: doc['dob'] != null ? DateTime.parse(doc['dob']) : null, // Convert String to DateTime
      favoriteGenres: List<String>.from(doc['favoriteGenres'] ?? []),
      phoneNumber: doc['phoneNumber'],
      gender: doc['gender'],
      friendRequests: List<String>.from(doc['friendRequests'] ?? []),
      friends: List<String>.from(doc['friends'] ?? []),
    );
  }
}
