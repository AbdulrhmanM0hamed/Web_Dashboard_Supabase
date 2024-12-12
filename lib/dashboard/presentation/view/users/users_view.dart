import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_dashboard/dashboard/presentation/view_model/users/users_state.dart';
import '../../view_model/users/users_cubit.dart';
import '../../../data/models/user_model.dart';

class UsersView extends StatelessWidget {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersCubit, UsersState>(
      builder: (context, state) {
        if (state is UsersInitialState) {
          context.read<UsersCubit>().loadUsers();
          return const Center(child: CircularProgressIndicator());
        } else if (state is UsersLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UsersLoadedState) {
          return _buildUsersList(context, state.users);
        } else if (state is UsersErrorState) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildUsersList(BuildContext context, List<UserModel> users) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<UsersCubit>().refreshUsers();
      },
      child: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text(user.name ?? 'No Name'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.email ?? 'No Email'),
                  Text('Phone: ${user.phoneNumber ?? 'Not provided'}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}