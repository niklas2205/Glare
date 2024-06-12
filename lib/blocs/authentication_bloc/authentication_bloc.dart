import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;
  late final StreamSubscription<MyUser?> _userSubscription;

  AuthenticationBloc({
    required this.userRepository
  }) : super(const AuthenticationState.unknown()) {
    _userSubscription = userRepository.user.listen((user) {
      add(AuthenticationUserchanged(user));
    });

    on<AuthenticationUserchanged>((event, emit) {
      print("Received user change event with user: ${event.user}");
      if(event.user != MyUser.empty) {
        print("Emitting Authenticated State");
        emit(AuthenticationState.authenticated(event.user!));
      } else {
        print("Emitting Unauthenticated State");
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
