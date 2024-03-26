import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<LoadUserData>(_onLoadUserData);
    on<UpdateFavoriteVenues>(_onUpdateFavoriteVenues);
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

  Future<void> _onUpdateFavoriteVenues(UpdateFavoriteVenues event, Emitter<UserState> emit) async {
    // Handle updating favorite venues logic
  }

}
