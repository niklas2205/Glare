part of 'change_genre_bloc.dart';

abstract class ChangeGenreState extends Equatable {
  const ChangeGenreState();

  @override
  List<Object> get props => [];
}

class ChangeGenreInitial extends ChangeGenreState {}

class ChangeGenreLoading extends ChangeGenreState {}

class ChangeGenreLoaded extends ChangeGenreState {
  final List<String> selectedGenres;

  const ChangeGenreLoaded(this.selectedGenres);

  @override
  List<Object> get props => [selectedGenres];
}

class ChangeGenreUpdated extends ChangeGenreState {}

class ChangeGenreError extends ChangeGenreState {
  final String error;

  const ChangeGenreError(this.error);

  @override
  List<Object> get props => [error];
}