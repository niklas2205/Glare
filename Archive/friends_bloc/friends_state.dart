// import 'package:equatable/equatable.dart';
// import 'package:user_repository/user_repository.dart';

// abstract class FriendsState extends Equatable {
//   const FriendsState();

//   @override
//   List<Object> get props => [];
// }

// class FriendsInitial extends FriendsState {}

// class FriendsLoadInProgress extends FriendsState {}

// class FriendsLoadSuccess extends FriendsState {
//   final List<MyUser> friends;

//   const FriendsLoadSuccess(this.friends);

//   @override
//   List<Object> get props => [friends];
// }

// class FriendRequestsLoadSuccess extends FriendsState {
//   final List<MyUser> friendRequests;

//   const FriendRequestsLoadSuccess(this.friendRequests);

//   @override
//   List<Object> get props => [friendRequests];
// }

// class SearchUsersSuccess extends FriendsState {
//   final List<MyUser> users;

//   const SearchUsersSuccess(this.users);

//   @override
//   List<Object> get props => [users];
// }

// class FriendsLoadFailure extends FriendsState {
//   final String message;

//   const FriendsLoadFailure(this.message);

//   @override
//   List<Object> get props => [message];
// }