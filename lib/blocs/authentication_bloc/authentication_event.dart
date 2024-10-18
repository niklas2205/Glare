part of 'authentication_bloc.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationUserchanged extends AuthenticationEvent {
  final MyUser? user;

  const AuthenticationUserchanged(this.user);

}

class AuthenticationErrorOccurred extends AuthenticationEvent {
  final String errorMessage;

  const AuthenticationErrorOccurred(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
