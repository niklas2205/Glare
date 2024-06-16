class MyUserEntity {
  String userId;
  String email;
  String? name;
  int? age;
  String? favoriteGenre;
  String? phoneNumber;
  String? gender;

  MyUserEntity({
    required this.userId,
    required this.email,
    required this.name,
    required this.age,
    this.favoriteGenre,
    this.phoneNumber,
    this.gender,
  });

  Map<String, Object?> toDocument() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'age': age,
      'favoriteGenre': favoriteGenre,
      'phoneNumber': phoneNumber,
      'gender': gender,
    };
  }

  static MyUserEntity fromDocument(Map<String, dynamic> doc) {
    return MyUserEntity(
      userId: doc['userId'],
      email: doc['email'],
      name: doc['name'],
      age: doc['age'],
      favoriteGenre: doc['favoriteGenre'],
      phoneNumber: doc['phoneNumber'],
      gender: doc['gender'],
    );
  }
}
