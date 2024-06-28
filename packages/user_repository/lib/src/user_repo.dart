import 'models/models.dart';

abstract class UserRepository {
  Stream<MyUser?> get user;
  Future<MyUser> signUp(MyUser myUser, String password);
  Future<void> setUserData(MyUser user);
  Future<MyUser?> getCurrentUser();
  Future<List<String>> fetchFavoriteVenueIds(String userId);
  Future<void> signIn(String email, String password);
  Future<void> logOut();
  Future<void> saveUserGenres(String userId, List<String> genres);
  Future<void> updateUserData(Map<String, dynamic> userData);

  Future<void> likeEvent(String userId, String eventId);
  Future<void> unlikeEvent(String userId, String eventId);
  Future<bool> isEventLiked(String userId, String eventId);
  Future<List<String>> getLikedEvents(String userId);  // Add this line
}