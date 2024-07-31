import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:glare/screens/home/blocs/friends_bloc/friends_state.dart';
import 'package:user_repository/user_repository.dart';

part 'friends_event.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  final UserRepository userRepository;

  FriendsBloc({required this.userRepository}) : super(FriendsInitial()) {
    on<LoadFriends>(_onLoadFriends);
    on<LoadFriendRequests>(_onLoadFriendRequests);
    on<SendFriendRequest>(_onSendFriendRequest);
    on<AcceptFriendRequest>(_onAcceptFriendRequest);
    on<DeclineFriendRequest>(_onDeclineFriendRequest);
    on<SearchUsers>(_onSearchUsers); // Add this line
  }

  Future<void> _onLoadFriends(LoadFriends event, Emitter<FriendsState> emit) async {
    emit(FriendsLoadInProgress());
    try {
      final currentUser = await userRepository.getCurrentUser();
      if (currentUser != null) {
        await emit.forEach<List<MyUser>>(
          userRepository.getFriends(currentUser.userId),
          onData: (friends) => FriendsLoadSuccess(friends),
          onError: (_, __) => FriendsLoadFailure("Failed to load friends"),
        );
      } else {
        emit(FriendsLoadFailure("User not logged in"));
      }
    } catch (e) {
      emit(FriendsLoadFailure(e.toString()));
    }
  }

  Future<void> _onLoadFriendRequests(LoadFriendRequests event, Emitter<FriendsState> emit) async {
    emit(FriendsLoadInProgress());
    try {
      final currentUser = await userRepository.getCurrentUser();
      if (currentUser != null) {
        await emit.forEach<List<MyUser>>(
          userRepository.getFriendRequests(currentUser.userId),
          onData: (friendRequests) => FriendRequestsLoadSuccess(friendRequests),
          onError: (_, __) => FriendsLoadFailure("Failed to load friend requests"),
        );
      } else {
        emit(FriendsLoadFailure("User not logged in"));
      }
    } catch (e) {
      emit(FriendsLoadFailure(e.toString()));
    }
  }

  Future<void> _onSendFriendRequest(SendFriendRequest event, Emitter<FriendsState> emit) async {
    try {
      final currentUser = await userRepository.getCurrentUser();
      if (currentUser != null) {
        await userRepository.sendFriendRequest(currentUser.userId, event.friendId);
        add(LoadFriendRequests());
      } else {
        emit(FriendsLoadFailure("User not logged in"));
      }
    } catch (e) {
      emit(FriendsLoadFailure(e.toString()));
    }
  }

  Future<void> _onAcceptFriendRequest(AcceptFriendRequest event, Emitter<FriendsState> emit) async {
    try {
      final currentUser = await userRepository.getCurrentUser();
      if (currentUser != null) {
        await userRepository.acceptFriendRequest(currentUser.userId, event.friendId);
        add(LoadFriends());
        add(LoadFriendRequests());
      } else {
        emit(FriendsLoadFailure("User not logged in"));
      }
    } catch (e) {
      emit(FriendsLoadFailure(e.toString()));
    }
  }

  Future<void> _onDeclineFriendRequest(DeclineFriendRequest event, Emitter<FriendsState> emit) async {
    try {
      final currentUser = await userRepository.getCurrentUser();
      if (currentUser != null) {
        await userRepository.rejectFriendRequest(currentUser.userId, event.friendId);
        add(LoadFriendRequests());
      } else {
        emit(FriendsLoadFailure("User not logged in"));
      }
    } catch (e) {
      emit(FriendsLoadFailure(e.toString()));
    }
  }

  Future<void> _onSearchUsers(SearchUsers event, Emitter<FriendsState> emit) async {
    emit(FriendsLoadInProgress());
    try {
      final users = event.query.isEmpty
          ? await userRepository.getFirstUsers(30)
          : await userRepository.searchUsers(event.query);
      emit(SearchUsersSuccess(users));
    } catch (e) {
      emit(FriendsLoadFailure(e.toString()));
    }
  }
}
