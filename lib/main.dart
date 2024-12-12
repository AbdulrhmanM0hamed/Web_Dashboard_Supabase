import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_dashboard/dashboard/presentation/view/categories/categories_view.dart';
import 'package:supabase_dashboard/dashboard/presentation/view/dashboard_view.dart';
import 'package:supabase_dashboard/dashboard/presentation/view/products/products_view.dart';
import 'package:supabase_dashboard/dashboard/presentation/view/special_offers/special_offers_view.dart'; // Added import
import 'package:supabase_dashboard/dashboard/presentation/view_model/special_offers/special_offers_cubit.dart';
import 'package:supabase_dashboard/generated/l10n.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/services/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  await Supabase.initialize(
    url: 'https://kizgmgaocdhnarvqtzvf.supabase.co', // Supabase URL
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtpemdtZ2FvY2RobmFydnF0enZmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzMzMjQ5NjksImV4cCI6MjA0ODkwMDk2OX0.LwosgMdM5ZcZAeVxn3b84lIeO4K6_-l4BsYF5pxxkJg', // Supabase Anon Key
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Cairo',
      ),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: Locale("ar"),
      routes: {
        '/': (context) => const DashboardView(),
        '/products': (context) => const ProductsView(),
        '/categories': (context) => const CategoriesView(),
        '/special-offers': (context) => BlocProvider(
              create: (context) => SpecialOffersCubit(),
              child: const SpecialOffersView(),
            )
      },
      // home: const DashboardView(),
    );
  }
}
