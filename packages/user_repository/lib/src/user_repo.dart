import 'models/models.dart';

abstract class UserRepository {
  Stream <MyUser?> get user;

  Future<MyUser> signUp(MyUser myUser, String password);

  Future<void> setUserData(MyUser user);

  Future<MyUser?> getCurrentUser();

  Future<List<String>> fetchFavoriteVenueIds(String userId);

  Future<void> signIn(String email, String password);

  Future<void> logOut();

   Future<void> saveUserGenres(String userId, List<String> genres); // Ensure this is declared

   Future<void> updateUserData(Map<String, dynamic> userData);
}