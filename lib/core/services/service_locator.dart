import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../dashboard/data/repositories/user_repository.dart';
import '../../dashboard/data/repositories/order_repository.dart';
import '../../dashboard/presentation/view_model/users/users_cubit.dart';
import '../../dashboard/presentation/view_model/orders/orders_cubit.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Core
  getIt.registerLazySingleton<SupabaseClient>(
    () => Supabase.instance.client,
  );

  // Repositories
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepository(getIt<SupabaseClient>()),
  );

  getIt.registerLazySingleton<OrderRepository>(
    () => OrderRepository(getIt<SupabaseClient>()),
  );

  // Cubits
  getIt.registerFactory<UsersCubit>(
    () => UsersCubit(getIt<UserRepository>()),
  );

  getIt.registerFactory<OrdersCubit>(
    () => OrdersCubit(getIt<OrderRepository>()),
  );
}
