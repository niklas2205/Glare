import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final UserRepository _userRepository;

  SignInBloc(this._userRepository) : super(SignInInitial()) {
    on<SignInWithAppleRequested>(_onSignInWithAppleRequested);
    on<SignInRequired>(_onSignInRequired);
    on<SignOutRequired>(_onSignOutRequired);
  }

  Future<void> _onSignInWithAppleRequested(
      SignInWithAppleRequested event, Emitter<SignInState> emit) async {
    emit(SignInProcess());
    try {
      await _userRepository.signInWithApple();
      emit(SignInSuccess());
    } catch (e) {
      emit(SignInFailure(error: e.toString()));
    }
  }

  Future<void> _onSignInRequired(
      SignInRequired event, Emitter<SignInState> emit) async {
    emit(SignInProcess());
    try {
      await _userRepository.signIn(event.email, event.password);
      emit(SignInSuccess());
    } catch (e) {
      emit(SignInFailure(error: e.toString()));
    }
  }

  Future<void> _onSignOutRequired(
      SignOutRequired event, Emitter<SignInState> emit) async {
    await _userRepository.logOut();
    emit(SignInInitial());
  }
}

