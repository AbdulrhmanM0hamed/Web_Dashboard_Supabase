import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_dashboard/dashboard/presentation/view_model/users/users_state.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/user_repository.dart';

class UsersCubit extends Cubit<UsersState> {
  final UserRepository userRepository;

  UsersCubit(this.userRepository) : super(const UsersInitialState());

  Future<void> loadUsers() async {
    emit(UsersLoadingState());
    try {
      final users = await userRepository.getUsers();
      emit(UsersLoadedState(users));
    } catch (e) {
      emit(UsersErrorState(e.toString()));
    }
  }

  Future<void> refreshUsers() async {
    try {
      final users = await  userRepository.getUsers();
      emit(UsersLoadedState(users));
    } catch (e) {
      emit(UsersErrorState(e.toString()));
    }
  }
}
