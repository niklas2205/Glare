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
    on<GenreSelected>((event, emit) {
      if (selectedGenres.contains(event.genre)) {
        selectedGenres.remove(event.genre);
      } else {
        selectedGenres.add(event.genre);
      }
      emit(GenresUpdated(List.from(selectedGenres)));
    });

    on<GenderChanged>((event, emit) {
      updatedUser = updatedUser.copyWith(gender: event.gender);
      emit(OnboardingDataSubmitted(updatedUser));
    });

    on<SubmitGenres>((event, emit) async {
      try {
        await userRepository.updateUserData({
          'genres': selectedGenres,
          'userId': updatedUser.userId, // Ensure userId is passed
        });
        emit(OnboardingCompletionSuccess());
      } catch (error) {
        emit(OnboardingFailure(error.toString()));
      }
    });

    on<OnboardingStarted>(_onStarted);
    on<OnboardingInfoSubmitted>(_onInfoSubmitted);
    on<OnboardingCompleted>(_onCompleted);
    on<SkipOnboarding>(_onSkipOnboarding);
  }

  void _onSkipOnboarding(SkipOnboarding event, Emitter<OnboardingState> emit) {
    userRepository.updateUserData({'age': 0, 'userId': updatedUser.userId});
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
      updatedUser = event.updatedUser.copyWith(userId: updatedUser.userId); // Ensure userId is copied
      await userRepository.setUserData(updatedUser);
      emit(OnboardingDataSubmitted(updatedUser));
    } catch (e) {
      emit(OnboardingFailure(e.toString()));
    }
  }

  void _onCompleted(OnboardingCompleted event, Emitter<OnboardingState> emit) async {
    try {
      await userRepository.updateUserData({
        'genres': selectedGenres,
        'userId': updatedUser.userId, // Ensure userId is passed
      });
      await userRepository.setUserData(updatedUser);
      emit(OnboardingCompletionSuccess());
    } catch (error) {
      emit(OnboardingFailure(error.toString()));
    }
  }
}
