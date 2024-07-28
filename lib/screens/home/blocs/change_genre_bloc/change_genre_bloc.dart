import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'change_genre_event.dart';
part 'change_genre_state.dart';

class ChangeGenreBloc extends Bloc<ChangeGenreEvent, ChangeGenreState> {
  final UserRepository userRepository;

  ChangeGenreBloc({required this.userRepository}) : super(ChangeGenreInitial()) {
    on<LoadUserGenres>(_onLoadUserGenres);
    on<GenreSelected>(_onGenreSelected);
    on<UpdateUserGenres>(_onUpdateUserGenres);
  }

  void _onLoadUserGenres(LoadUserGenres event, Emitter<ChangeGenreState> emit) async {
    emit(ChangeGenreLoading());
    try {
      final user = await userRepository.getCurrentUser();
      final selectedGenres = user?.favoriteGenre?.split(',') ?? [];
      emit(ChangeGenreLoaded(selectedGenres));
    } catch (e) {
      emit(ChangeGenreError(e.toString()));
    }
  }

  void _onGenreSelected(GenreSelected event, Emitter<ChangeGenreState> emit) {
    if (state is ChangeGenreLoaded) {
      final currentState = state as ChangeGenreLoaded;
      final updatedGenres = List<String>.from(currentState.selectedGenres);
      if (updatedGenres.contains(event.genre)) {
        updatedGenres.remove(event.genre);
      } else {
        updatedGenres.add(event.genre);
      }
      emit(ChangeGenreLoaded(updatedGenres));
    }
  }

  void _onUpdateUserGenres(UpdateUserGenres event, Emitter<ChangeGenreState> emit) async {
    emit(ChangeGenreLoading());
    try {
      final user = await userRepository.getCurrentUser();
      if (user != null) {
        await userRepository.saveUserGenres(user.userId, event.genres);
        emit(ChangeGenreUpdated());
      } else {
        emit(ChangeGenreError("User not found"));
      }
    } catch (e) {
      emit(ChangeGenreError(e.toString()));
    }
  }
}