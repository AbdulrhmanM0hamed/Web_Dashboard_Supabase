import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_dashboard/dashboard/presentation/view/categories/widgets/category_card.dart';
import 'package:supabase_dashboard/dashboard/presentation/view/categories/widgets/search_bar.dart';
import 'package:supabase_dashboard/dashboard/presentation/view/categories/widgets/categories_app_bar.dart';
import 'package:supabase_dashboard/dashboard/presentation/view_model/categories/categories_cubit.dart';


class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CategoriesAppBar(),
      body: Column(
        children: [
          SearchBarWidget(
            searchController: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
              });
            },
            onClear: () {
              setState(() {
                _searchController.clear();
                _searchQuery = '';
              });
            },
          ),
          Expanded(
            child: BlocBuilder<CategoriesCubit, CategoriesState>(
              builder: (context, state) {
                if (state is CategoriesInitial) {
                  context.read<CategoriesCubit>().loadCategories();
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is CategoriesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is CategoriesError) {
                  return Center(
                    child: Text(state.message),
                  );
                }
                if (state is CategoriesLoaded) {
                  final filteredCategories = state.categories
                      .where((category) => category.name
                          .toLowerCase()
                          .contains(_searchQuery))
                      .toList();

                  if (filteredCategories.isEmpty) {
                    return const Center(child: Text('لا توجد نتائج.'));
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1.2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredCategories.length,
                    itemBuilder: (context, index) {
                      final category = filteredCategories[index];
                      return CategoryCard(category: category);
                    },
                  );
                }
                return const Center(child: Text('حالة غير معروفة'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
