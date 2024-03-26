part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final MyUser user;
  final List<String> favoriteVenueIds;

  UserLoaded(this.user, this.favoriteVenueIds);

  @override
  List<Object> get props => [user, favoriteVenueIds];
}

class UserError extends UserState {
  final String message;

  UserError(this.message);

  @override
  List<Object> get props => [message];
}