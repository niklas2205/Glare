part of 'onboarding_bloc.dart';

// onboarding_state.dart
abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object> get props => [];
}

class OnboardingInitial extends OnboardingState {}

class OnboardingLoadInProgress extends OnboardingState {}

class OnboardingDataSubmitted extends OnboardingState {
  final MyUser user;

  const OnboardingDataSubmitted(this.user);

  @override
  List<Object> get props => [user];
}

class OnboardingCompletionSuccess extends OnboardingState {}
