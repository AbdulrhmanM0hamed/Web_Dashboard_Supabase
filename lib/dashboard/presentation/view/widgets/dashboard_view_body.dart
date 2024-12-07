import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_dashboard/dashboard/presentation/view/categories/categories_view.dart';
import 'package:supabase_dashboard/dashboard/presentation/view/products/products_view.dart';
import 'package:supabase_dashboard/dashboard/presentation/view/special_offers/special_offers_view.dart';
import 'package:supabase_dashboard/dashboard/presentation/view/widgets/dashboard_card_widget.dart';
import 'package:supabase_dashboard/dashboard/presentation/view/widgets/dashboard_content.dart';

import 'package:supabase_dashboard/dashboard/presentation/view/widgets/side_menu.dart';
import 'package:supabase_dashboard/dashboard/presentation/view_model/categories/categories_cubit.dart';
import 'package:supabase_dashboard/dashboard/presentation/view_model/products/products_cubit.dart';
import 'package:supabase_dashboard/dashboard/presentation/view_model/special_offers/special_offers_cubit.dart';

class DashboardViewBody extends StatefulWidget {
  final int selectedIndex;

  const DashboardViewBody({
    super.key,
    required this.selectedIndex,
  });

  @override
  State<DashboardViewBody> createState() => _DashboardViewBodyState();
}

class _DashboardViewBodyState extends State<DashboardViewBody> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 300,
                minWidth: 250,
              ),
              child: SideMenu(
                selectedIndex: _selectedIndex,
                onItemSelected: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(24.0),
                child: IndexedStack(
                  index: _selectedIndex,
                  children: [
                MultiBlocProvider(
                  providers: [
                    BlocProvider<ProductsCubit>(
                      create: (context) => ProductsCubit()..loadProducts(),
                    ),
                    BlocProvider<CategoriesCubit>(
                      create: (context) => CategoriesCubit()..loadCategories(),
                    ),
                    BlocProvider<SpecialOffersCubit>(
                      create: (context) => SpecialOffersCubit()..loadSpecialOffers(),
                    ),
                  ],
                  child: const DashboardContenet(),
                ),
                BlocProvider<ProductsCubit>(
                  create: (context) => ProductsCubit()..loadProducts(),
                  child: const ProductsView(),
                ),
                BlocProvider<SpecialOffersCubit>(
                  create: (context) => SpecialOffersCubit()..loadSpecialOffers(),
                  child: const SpecialOffersView(),
                ),
                BlocProvider<CategoriesCubit>(
                  create: (context) => CategoriesCubit()..loadCategories(),
                  child: const CategoriesView(),
                ),
              ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }





}

