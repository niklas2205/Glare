import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;
  late final StreamSubscription<MyUser?> _userSubscription;

  AuthenticationBloc({required this.userRepository})
      : super(const AuthenticationState.unknown()) {
    _userSubscription = userRepository.user.listen(
      (user) {
        add(AuthenticationUserchanged(user));
      },
      onError: (error) {
        add(AuthenticationErrorOccurred(error.toString()));
      },
    );

    on<AuthenticationUserchanged>((event, emit) {
      print("AuthenticationUserchanged event triggered: ${event.user}");
      if (event.user != null && event.user != MyUser.empty) {
        print("User authenticated: ${event.user}");
        emit(AuthenticationState.authenticated(event.user!));
      } else {
        print("User unauthenticated or empty: ${event.user}");
        emit(const AuthenticationState.unauthenticated());
      }
    });

  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}

