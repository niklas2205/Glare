import '../entities/entities.dart';

class MyUser {
  String userId;
  String email;
  String? name;
  int? age;
  String? favoriteGenre;
  String? phoneNumber;
  String? gender;

  MyUser({
    required this.userId,
    required this.email,
    this.name,
    this.age,
    this.favoriteGenre,
    this.phoneNumber,
    this.gender,
  });

  static final empty = MyUser(
    userId: '',
    email: '',
    name: '',
    age: 0,
    gender: '',
  );

  MyUserEntity toEntity() {
    return MyUserEntity(
      userId: userId,
      email: email,
      name: name,
      age: age,
      favoriteGenre: favoriteGenre,
      phoneNumber: phoneNumber,
      gender: gender,
    );
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
      userId: entity.userId,
      email: entity.email,
      name: entity.name,
      age: entity.age,
      favoriteGenre: entity.favoriteGenre,
      phoneNumber: entity.phoneNumber,
      gender: entity.gender,
    );
  }

  MyUser copyWith({
    String? userId,
    String? email,
    String? name,
    int? age,
    String? favoriteGenre,
    String? phoneNumber,
    String? gender,
  }) {
    return MyUser(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      name: name ?? this.name,
      age: age ?? this.age,
      favoriteGenre: favoriteGenre ?? this.favoriteGenre,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
    );
  }

  @override
  String toString() {
    return 'MyUser: $userId, $email, $name, $age, $gender';
  }
}
