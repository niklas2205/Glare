part of 'authentication_bloc.dart';

enum AuthenticationStatus {authenticated, unauthenticated, unknown, error}

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.user,
    this.errorMessage,
  });

  final AuthenticationStatus status;
  final MyUser? user;
  final String? errorMessage;

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(MyUser myUser)
      : this._(status: AuthenticationStatus.authenticated, user: myUser);

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  const AuthenticationState.error(String errorMessage)
      : this._(status: AuthenticationStatus.error, errorMessage: errorMessage);

  @override
  List<Object?> get props => [status, user, errorMessage];
}
