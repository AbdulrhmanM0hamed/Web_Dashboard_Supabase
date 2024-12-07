import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_dashboard/core/services/supabase_service.dart';
import 'package:supabase_dashboard/dashboard/presentation/view/categories/categories_view.dart';
import 'package:supabase_dashboard/dashboard/presentation/view/dashboard_view.dart';
import 'package:supabase_dashboard/dashboard/presentation/view/products/products_view.dart';
import 'package:supabase_dashboard/dashboard/presentation/view/special_offers/special_offers_view.dart';
import 'package:supabase_dashboard/dashboard/presentation/view_model/categories/categories_cubit.dart';
import 'package:supabase_dashboard/dashboard/presentation/view_model/products/products_cubit.dart';
import 'package:supabase_dashboard/dashboard/presentation/view_model/special_offers/special_offers_cubit.dart';

class AppRouter {
  final SupabaseService supabaseService;

  AppRouter(this.supabaseService);

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const DashboardView(),
        );

      case '/products':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => ProductsCubit(),
            child: const ProductsView(),
          ),
        );

      case '/categories':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => CategoriesCubit(),
            child: const CategoriesView(),
          ),
        );

      case '/special-offers':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => SpecialOffersCubit(),
            child: const SpecialOffersView(),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
