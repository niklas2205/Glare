import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final UserRepository userRepository;
  List<String> selectedGenres = [];

  OnboardingBloc({required this.userRepository}) : super(OnboardingInitial()) {
    on<GenreSelected>((event, emit) {
      // Toggle genre selection logic
      if (selectedGenres.contains(event.genre)) {
        selectedGenres.remove(event.genre);
      } else {
        selectedGenres.add(event.genre);
      }
      emit(GenresUpdated(List.from(selectedGenres))); // Properly emit a new state
    });

    on<SubmitGenres>((event, emit) {
      // Logic to submit selected genres, maybe save them to user profile
      emit(OnboardingCompletionSuccess()); // Assume submission is immediate success for this example
    });

    on<OnboardingStarted>(_onStarted);
    on<OnboardingInfoSubmitted>(_onInfoSubmitted);
    on<OnboardingCompleted>(_onCompleted);
    on<SkipOnboarding>(_onSkipOnboarding);
  }



  void _onSkipOnboarding(SkipOnboarding event, Emitter<OnboardingState> emit) {
    // Logic to set the age to 0 and complete onboarding
    userRepository.updateUserData({'age': 0});
    emit(OnboardingCompletionSuccess());
  }
  
  
  Future<void> _onStarted(OnboardingStarted event, Emitter<OnboardingState> emit) async {
    try {
        final MyUser? user = await userRepository.getCurrentUser();
        print("User fetched: $user");
        if (user != null && user.age != null) {
            print("User is valid and age is set, emitting OnboardingCompletionSuccess.");
            emit(OnboardingCompletionSuccess());
        } else {
            print("User is null or age not set, emitting OnboardingRequired.");
            emit(OnboardingRequired()); // New state indicating specific need for onboarding data
        }
    } catch (e) {
        print("Error fetching user: $e");
        emit(OnboardingFailure(e.toString())); // Emit failure state on error
    }
}


  void _onInfoSubmitted(OnboardingInfoSubmitted event, Emitter<OnboardingState> emit) async {
    emit(OnboardingLoadInProgress());
    try {
        await userRepository.setUserData(event.updatedUser); // Update the user data in the repository
        // Fetch the user again to confirm the age was properly set
        final MyUser? updatedUser = await userRepository.getCurrentUser();
        if (updatedUser != null && updatedUser.age != null) {
            emit(OnboardingCompletionSuccess()); // If age is now set, emit success
        } else {
            emit(const OnboardingFailure("Failed to verify user's age, onboarding cannot be completed.")); // Failure if age is not set
        }
    } catch (e) {
        emit(OnboardingFailure(e.toString())); // Emit failure on exceptions
    }
}

  void _onCompleted(OnboardingCompleted event, Emitter<OnboardingState> emit) {
    emit(OnboardingCompletionSuccess());
  }
}
