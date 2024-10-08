part of 'onboarding_bloc.dart';

// onboarding_event.dart
abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object> get props => [];
}

class OnboardingStarted extends OnboardingEvent {}

class SkipOnboarding extends OnboardingEvent {}

class OnboardingInfoSubmitted extends OnboardingEvent {
  final MyUser updatedUser;

  const OnboardingInfoSubmitted(this.updatedUser);

  @override
  List<Object> get props => [updatedUser];
}

class GenderChanged extends OnboardingEvent {
  final String gender;

  const GenderChanged(this.gender);

  @override
  List<Object> get props => [gender];
}

class OnboardingCompleted extends OnboardingEvent {}

class GenreSelected extends OnboardingEvent {
  final String genre;

  const GenreSelected(this.genre);

  @override
  List<Object> get props => [genre];
}


class SubmitGenres extends OnboardingEvent {}

class LoadUserGenres extends OnboardingEvent {}