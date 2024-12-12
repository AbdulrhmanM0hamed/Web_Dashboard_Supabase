import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../dashboard/data/repositories/user_repository.dart';
import '../../dashboard/presentation/view_model/users/users_cubit.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Repositories
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepository(Supabase.instance.client),
  );

  // Cubits
  getIt.registerFactory<UsersCubit>(
    () => UsersCubit(getIt<UserRepository>()),
  );
}
