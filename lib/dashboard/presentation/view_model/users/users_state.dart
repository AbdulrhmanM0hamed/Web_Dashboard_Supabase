import 'package:equatable/equatable.dart';
import '../../../data/models/user_model.dart';

abstract class UsersState extends Equatable {
  const UsersState();

  @override
  List<Object> get props => [];
}

class UsersInitialState extends UsersState {
  const UsersInitialState();
}

class UsersLoadingState extends UsersState {}

class UsersLoadedState extends UsersState {
  final List<UserModel> users;

  const UsersLoadedState(this.users);

  @override
  List<Object> get props => [users];
}

class UsersErrorState extends UsersState {
  final String message;
  
  const UsersErrorState(this.message);

  @override
  List<Object> get props => [message];
}
