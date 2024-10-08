part of 'user_update_bloc.dart';

abstract class UserUpdateEvent extends Equatable {
  const UserUpdateEvent();

  @override
  List<Object> get props => [];
}

class UpdateUserDetails extends UserUpdateEvent {
  final Map<String, dynamic> userData;

  const UpdateUserDetails(this.userData);

  @override
  List<Object> get props => [userData];
}
