import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

// onboarding_bloc.dart

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final UserRepository userRepository;

  OnboardingBloc({required this.userRepository}) : super(OnboardingInitial()) {
    on<OnboardingStarted>(_onStarted);
    on<OnboardingInfoSubmitted>(_onInfoSubmitted);
    on<OnboardingCompleted>(_onCompleted);
  }

  void _onStarted(OnboardingStarted event, Emitter<OnboardingState> emit) {
    emit(OnboardingLoadInProgress());
    // You can fetch initial data if needed
  }

  void _onInfoSubmitted(OnboardingInfoSubmitted event, Emitter<OnboardingState> emit) async {
    emit(OnboardingLoadInProgress());
    await userRepository.setUserData(event.updatedUser);
    emit(OnboardingDataSubmitted(event.updatedUser));
  }

  void _onCompleted(OnboardingCompleted event, Emitter<OnboardingState> emit) {
    emit(OnboardingCompletionSuccess());
    // Perform any cleanup or final steps needed post-onboarding
  }
}
