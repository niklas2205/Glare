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
    on<GenderChanged>(_onGenderChanged);
  }

  

  void _onSkipOnboarding(SkipOnboarding event, Emitter<OnboardingState> emit) async {
  try {
    // Ensure updatedUser has the latest user data
    final MyUser? user = await userRepository.getCurrentUser();
    if (user != null) {
      updatedUser = user;
    }

    // Generate the default name using the first four characters of the user ID
    String defaultName = 'User ${updatedUser.userId.substring(0, 4)}';

    // Update the user data with the default name
    await userRepository.updateUserData({
      'userId': updatedUser.userId,
      'name': defaultName,
    });

    emit(OnboardingCompletionSuccess());
  } catch (e) {
    emit(OnboardingFailure(e.toString()));
  }
}

  Future<void> _onStarted(OnboardingStarted event, Emitter<OnboardingState> emit) async {
  print('OnboardingBloc: Processing OnboardingStarted event');
  emit(OnboardingLoadInProgress());
  try {
    final MyUser? user = await userRepository.getCurrentUser();
    print('OnboardingBloc: Fetched user data: $user');

    if (user != null) {
      updatedUser = user;
      bool isComplete = true;

      if (user.name == "" || user.name == null) {
        isComplete = false;
        print("OnboardingBloc: Name is incomplete.");
      }



      if (isComplete) {
        print("OnboardingBloc: Onboarding complete, emitting OnboardingCompletionSuccess.");
        emit(OnboardingCompletionSuccess());
      } else {
        print("OnboardingBloc: Onboarding required, emitting OnboardingRequired.");
        emit(OnboardingRequired());
      }
    } else {
      updatedUser = MyUser.empty;
      emit(OnboardingRequired());
    }
  } catch (e) {
    print("OnboardingBloc: Error during onboarding check: $e");
    emit(OnboardingFailure(e.toString()));
  }
}


  void _onInfoSubmitted(OnboardingInfoSubmitted event, Emitter<OnboardingState> emit) async {
  emit(OnboardingLoadInProgress());
  try {
    // Check if the name is empty or contains only whitespace
     String fullName = (event.updatedUser.name ?? "").trim();
    if (fullName.isEmpty) {
      // Generate the default name using the first four characters of the user ID
      String defaultName = 'User ${event.updatedUser.userId.substring(0, 4)}';
      fullName = defaultName;
    }

    // Create an updated user with the name
    updatedUser = event.updatedUser.copyWith(
      userId: updatedUser.userId,
      email: updatedUser.email, // Ensure email is retained
      name: fullName, // Use the default or provided name
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
        'dateOfBirth': updatedUser.dateOfBirth,
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
void _onGenderChanged(GenderChanged event, Emitter<OnboardingState> emit) {
  // Update the gender in the updatedUser object
  updatedUser = updatedUser.copyWith(gender: event.gender);
}






}
