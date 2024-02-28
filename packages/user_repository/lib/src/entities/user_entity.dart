class MyUserEntity {
  String userId;
  String email;
  String name;
  bool hasActiveCart;
  DateTime age; // Make DateTime non-nullable
  String? favoriteGenre;
  String? phoneNumber;

  MyUserEntity({
    required this.userId,
    required this.email,
    required this.name,
    required this.hasActiveCart,
    required this.age, // Make age required
    this.favoriteGenre,
    this.phoneNumber,
  });

  Map<String, Object?> toDocument() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'hasActiveCart': hasActiveCart,
      'age': age.toIso8601String(), // No need for null check
      'favoriteGenre': favoriteGenre,
      'phoneNumber': phoneNumber,
    };
  }

  static MyUserEntity fromDocument(Map<String, dynamic> doc) {
    return MyUserEntity(
      userId: doc['userId'],
      email: doc['email'],
      name: doc['name'],
      hasActiveCart: doc['hasActiveCart'],
      age: DateTime.parse(doc['age']), // Directly parse as DateTime is non-nullable
      favoriteGenre: doc['favoriteGenre'],
      phoneNumber: doc['phoneNumber'],
    );
  }
}