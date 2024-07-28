part of 'change_genre_bloc.dart';

abstract class ChangeGenreEvent extends Equatable {
  const ChangeGenreEvent();

  @override
  List<Object> get props => [];
}

class LoadUserGenres extends ChangeGenreEvent {}

class GenreSelected extends ChangeGenreEvent {
  final String genre;

  const GenreSelected(this.genre);

  @override
  List<Object> get props => [genre];
}

class UpdateUserGenres extends ChangeGenreEvent {
  final List<String> genres;

  const UpdateUserGenres(this.genres);

  @override
  List<Object> get props => [genres];
}