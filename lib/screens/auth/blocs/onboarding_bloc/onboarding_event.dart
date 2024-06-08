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

class OnboardingCompleted extends OnboardingEvent {}


class GenderChanged extends OnboardingEvent {
  final String gender;
  const GenderChanged(this.gender);
}

class GenreSelected extends OnboardingEvent {
  final String genre;
  GenreSelected(this.genre);
}

class SubmitGenres extends OnboardingEvent {}
