import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'user_update_event.dart';
part 'user_update_state.dart';

class UserUpdateBloc extends Bloc<UserUpdateEvent, UserUpdateState> {
  final UserRepository userRepository;

  UserUpdateBloc({required this.userRepository}) : super(UserUpdateInitial()) {
    on<UpdateUserDetails>(_onUpdateUserDetails);
  }

  void _onUpdateUserDetails(UpdateUserDetails event, Emitter<UserUpdateState> emit) async {
    emit(UserUpdateLoading());
    try {
      await userRepository.updateUserData(event.userData);
      emit(UserUpdateSuccess());
    } catch (e) {
      emit(UserUpdateFailure(e.toString()));
    }
  }
}
