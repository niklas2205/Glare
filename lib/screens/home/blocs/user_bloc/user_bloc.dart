import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<LoadUserData>(_onLoadUserData);
    on<FetchUserData>(_onFetchUserData); // Add this line
    on<UpdateFavoriteVenues>(_onUpdateFavoriteVenues);
    on<RefreshUserFavorites>(_onRefreshUserFavorites);
    // ... other event handlers ...
  }

  Future<void> _onLoadUserData(LoadUserData event, Emitter<UserState> emit) async {
    try {
      emit(UserLoading());
      final user = await userRepository.getCurrentUser();
      if (user != null) {
        // Now that we've checked user is not null, it's safe to access userId
        final favoriteVenueIds = await userRepository.fetchFavoriteVenueIds(user.userId);
        emit(UserLoaded(user, favoriteVenueIds));
      } else {
        emit(UserError("User not found"));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onFetchUserData(FetchUserData event, Emitter<UserState> emit) async {
    try {
      final user = await userRepository.getCurrentUser();
      if (user != null) {
        final favoriteVenueIds = await userRepository.fetchFavoriteVenueIds(user.userId);
        emit(UserLoaded(user, favoriteVenueIds));
      } else {
        emit(UserError("User not found"));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }


  void _onUpdateFavoriteVenues(UpdateFavoriteVenues event, Emitter<UserState> emit) {
  if (state is UserLoaded) {
    // Assuming you have the current user data in the state
    final currentUser = (state as UserLoaded).user;
    // Emit new state with updated favorite venue IDs
    emit(UserLoaded(currentUser, event.favoriteVenueIds));
  }
}
  void _onRefreshUserFavorites(RefreshUserFavorites event, Emitter<UserState> emit) async {
    try {
      if (state is UserLoaded) {
        final currentUser = (state as UserLoaded).user;
        final updatedFavoriteVenueIds = await userRepository.fetchFavoriteVenueIds(currentUser.userId);
        print('Updated favorites: $updatedFavoriteVenueIds'); // Debugging statement
        emit(UserLoaded(currentUser, updatedFavoriteVenueIds));
      }
    } catch (e) {
      print('Error in refreshing favorites: $e'); // Debugging statement
    }
  }
}
