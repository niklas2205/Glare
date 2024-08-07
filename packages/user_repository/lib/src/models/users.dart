import '../entities/entities.dart';

class MyUser {
  String userId;
  String email;
  String? name;
  DateTime? dob; // Changed from int? age to DateTime? dob
  List<String>? favoriteGenres;
  String? phoneNumber;
  String? gender;
  List<String>? friendRequests; // List of userIds who sent friend requests
  List<String>? friends; // List of userIds who are friends

  MyUser({
    required this.userId,
    required this.email,
    this.name,
    this.dob,
    this.favoriteGenres,
    this.phoneNumber,
    this.gender,
    this.friendRequests,
    this.friends,
  });

  static final empty = MyUser(
    userId: '',
    email: '',
    name: '',
    dob: null, // Changed from age: 0 to dob: null
    favoriteGenres: [],
    gender: '',
    friendRequests: [],
    friends: [],
  );

  MyUserEntity toEntity() {
    return MyUserEntity(
      userId: userId,
      email: email,
      name: name,
      dob: dob,
      favoriteGenres: favoriteGenres,
      phoneNumber: phoneNumber,
      gender: gender,
      friendRequests: friendRequests,
      friends: friends,
    );
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
      userId: entity.userId,
      email: entity.email,
      name: entity.name,
      dob: entity.dob,
      favoriteGenres: entity.favoriteGenres,
      phoneNumber: entity.phoneNumber,
      gender: entity.gender,
      friendRequests: entity.friendRequests,
      friends: entity.friends,
    );
  }

  MyUser copyWith({
    String? userId,
    String? email,
    String? name,
    DateTime? dob,
    List<String>? favoriteGenres,
    String? phoneNumber,
    String? gender,
    List<String>? friendRequests,
    List<String>? friends,
  }) {
    return MyUser(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      name: name ?? this.name,
      dob: dob ?? this.dob,
      favoriteGenres: favoriteGenres ?? this.favoriteGenres,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      friendRequests: friendRequests ?? this.friendRequests,
      friends: friends ?? this.friends,
    );
  }

  @override
  String toString() {
    return 'MyUser: $userId, $email, $name, $dob, $favoriteGenres, $gender, $friendRequests, $friends';
  }
}
