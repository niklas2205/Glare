import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final UserRepository userRepository;
  List<String> selectedGenres = [];
  MyUser updatedUser = MyUser.empty;

  OnboardingBloc({required this.userRepository}) : super(OnboardingInitial()) {
    on<OnboardingStarted>(_onStarted);
    on<OnboardingInfoSubmitted>(_onInfoSubmitted);
    on<OnboardingCompleted>(_onCompleted);
    on<SkipOnboarding>(_onSkipOnboarding);
    on<GenreSelected>(_onGenreSelected);
    on<SubmitGenres>(_onSubmitGenres);
    on<LoadUserGenres>(_onLoadUserGenres);
  }

  void _onSkipOnboarding(SkipOnboarding event, Emitter<OnboardingState> emit) {
    userRepository.updateUserData({
      'age': 0,
      'userId': updatedUser.userId,
    });
    emit(OnboardingCompletionSuccess());
  }

  Future<void> _onStarted(OnboardingStarted event, Emitter<OnboardingState> emit) async {
    try {
      final MyUser? user = await userRepository.getCurrentUser();
      if (user != null && user.age != null) {
        updatedUser = user;
        emit(OnboardingCompletionSuccess());
      } else {
        updatedUser = user ?? MyUser.empty;
        emit(OnboardingRequired());
      }
    } catch (e) {
      emit(OnboardingFailure(e.toString()));
    }
  }

  void _onInfoSubmitted(OnboardingInfoSubmitted event, Emitter<OnboardingState> emit) async {
    emit(OnboardingLoadInProgress());
    try {
      updatedUser = event.updatedUser.copyWith(
        userId: updatedUser.userId,
        email: updatedUser.email, // Ensure email is retained
      );
      await userRepository.setUserData(updatedUser);
      emit(OnboardingDataSubmitted(updatedUser));
    } catch (e) {
      emit(OnboardingFailure(e.toString()));
    }
  }

  void _onCompleted(OnboardingCompleted event, Emitter<OnboardingState> emit) async {
    try {
      await userRepository.updateUserData({
        'favoriteGenres': selectedGenres,
        'gender': updatedUser.gender,
        'userId': updatedUser.userId, // Ensure userId is passed
        'name': updatedUser.name,
        'age': updatedUser.age,
        'phoneNumber': updatedUser.phoneNumber,
      });
      emit(OnboardingCompletionSuccess());
    } catch (error) {
      emit(OnboardingFailure(error.toString()));
    }
  }

  void _onGenreSelected(GenreSelected event, Emitter<OnboardingState> emit) {
    if (selectedGenres.contains(event.genre)) {
      selectedGenres.remove(event.genre);
    } else {
      selectedGenres.add(event.genre);
    }
    emit(GenresUpdated(List.from(selectedGenres)));
  }


  void _onSubmitGenres(SubmitGenres event, Emitter<OnboardingState> emit) async {
    try {
      await userRepository.updateUserData({
        'favoriteGenres': selectedGenres,
        'gender': updatedUser.gender,
        'userId': updatedUser.userId, // Ensure userId is passed
      });
      emit(OnboardingCompletionSuccess());
    } catch (error) {
      emit(OnboardingFailure(error.toString()));
    }
  }

  void _onLoadUserGenres(LoadUserGenres event, Emitter<OnboardingState> emit) async {
  emit(OnboardingLoadInProgress());
  try {
    final MyUser? user = await userRepository.getCurrentUser();
    if (user != null) {
      print("User data: ${user.toString()}"); // Debugging log
      if (user.favoriteGenres != null && user.favoriteGenres!.isNotEmpty) {
        selectedGenres = List<String>.from(user.favoriteGenres!);
        print("Parsed genres: $selectedGenres"); // Debugging log
      } else {
        print("No favoriteGenres found in user data."); // Debugging log
      }
      emit(GenresUpdated(List.from(selectedGenres)));
    } else {
      print("No user found."); // Debugging log
      emit(GenresUpdated([]));
    }
  } catch (e) {
    print("Error loading user genres: $e"); // Debugging log
    emit(OnboardingFailure(e.toString()));
  }
}



}
