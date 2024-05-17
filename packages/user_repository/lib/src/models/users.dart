import '../entities/entities.dart';

class MyUser {
  String userId;
  String email;
  String? name;
  int? age; // Nullable DateTime for age
  String? favoriteGenre; // Nullable String for favorite genre
  String? phoneNumber; // Nullable String for phone number

  MyUser({
    required this.userId,
    required this.email,
    this.name,
    this.age,
    this.favoriteGenre,
    this.phoneNumber,
  });

  static final empty =MyUser(
    userId: '',
    email: '',
    name: '',
    age: 0,
    );

  MyUserEntity toEntity() {
    return MyUserEntity(
      userId: userId,
      email: email,
      name: name,
      age: age, // Include age
      favoriteGenre: favoriteGenre, // Include favorite genre
      phoneNumber: phoneNumber, // Include phone number
    );
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
      userId: entity.userId,
      email: entity.email,
      name: entity.name,
      age: entity.age, // Assign age
      favoriteGenre: entity.favoriteGenre,
      phoneNumber: entity.phoneNumber,
    );
  }

  @override
  String toString() {
    return 'MyUser: $userId, $email, $name, $age';
  }
}