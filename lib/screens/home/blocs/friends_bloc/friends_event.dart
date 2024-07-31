part of 'friends_bloc.dart';




abstract class FriendsEvent extends Equatable {
  const FriendsEvent();

  @override
  List<Object> get props => [];
}

class LoadFriends extends FriendsEvent {}

class LoadFriendRequests extends FriendsEvent {}

class SearchUsers extends FriendsEvent {
  final String query;

  const SearchUsers(this.query);

  @override
  List<Object> get props => [query];
}

class SendFriendRequest extends FriendsEvent {
  final String friendId;

  const SendFriendRequest(this.friendId);

  @override
  List<Object> get props => [friendId];
}

class AcceptFriendRequest extends FriendsEvent {
  final String friendId;

  const AcceptFriendRequest(this.friendId);

  @override
  List<Object> get props => [friendId];
}

class DeclineFriendRequest extends FriendsEvent {
  final String friendId;

  const DeclineFriendRequest(this.friendId);

  @override
  List<Object> get props => [friendId];
}
