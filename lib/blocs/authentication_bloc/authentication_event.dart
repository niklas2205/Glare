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