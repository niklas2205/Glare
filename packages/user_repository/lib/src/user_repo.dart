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
  Future<List<String>> getLikedEvents(String userId);

  Future<void> sendFriendRequest(String userId, String friendId);
  Future<void> acceptFriendRequest(String userId, String friendId);
  Future<void> rejectFriendRequest(String userId, String friendId); // Added this line
  Future<List<MyUser>> searchUsers(String query);
  Stream<List<MyUser>> getFriends(String userId); // Changed to Stream
  Stream<List<MyUser>> getFriendRequests(String userId); // Added this line

  Future<List<MyUser>> getFirstUsers(int limit); // Add this line

  MyUser? get currentUser;
}

