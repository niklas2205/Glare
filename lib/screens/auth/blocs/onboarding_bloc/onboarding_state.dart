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

class OnboardingRequired extends OnboardingState {}

class OnboardingCompletionSuccess extends OnboardingState {}

class OnboardingFailure extends OnboardingState {
  final String errorMessage;

  const OnboardingFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class GenresUpdated extends OnboardingState {
  final List<String> genres;

  const GenresUpdated(this.genres);

  @override
  List<Object> get props => [genres];
}