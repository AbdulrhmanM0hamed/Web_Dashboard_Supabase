import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_dashboard/dashboard/presentation/view/widgets/dashboard_card_widget.dart';
import 'package:supabase_dashboard/dashboard/presentation/view_model/dashboard/dashboard_cubit.dart';
import 'package:supabase_dashboard/dashboard/presentation/view_model/products/products_cubit.dart';

class DashboardContenet extends StatefulWidget {
  const DashboardContenet({super.key});

  @override
  State<DashboardContenet> createState() => _DashboardContenetState();
}

class _DashboardContenetState extends State<DashboardContenet> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().loadDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is DashboardError) {
          return Center(
            child: Text(
              'حدث خطأ: ${state.message}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (state is DashboardLoaded) {
          return GridView.count(
            crossAxisCount: 4,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 1.5,
            children: [
              DashboardCard(
                icon: Icons.shopping_bag,
                title: 'المنتجات',
                value: state.productsCount.toString(),
                color: Colors.blue,
              ),
              DashboardCard(
                icon: Icons.category,
                title: 'التصنيفات',
                value: state.categoriesCount.toString(),
                color: Colors.green,
              ),
              DashboardCard(
                icon: Icons.people,
                title: 'المستخدمين',
                value: state.usersCount.toString(),
                color: Colors.orange,
              ),
              DashboardCard(
                icon: Icons.shopping_cart,
                title: 'الطلبات',
                value: state.ordersCount.toString(),
                color: Colors.orange,
              ),
              MostSoldProductCard(),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}

class MostSoldProductCard extends StatelessWidget {
  const MostSoldProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        if (state is ProductsMostSoldLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProductsMostSoldLoaded) {
          final product = state.product;
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'المنتج الأكثر مبيعاً',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  if (product.imageUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        product.imageUrl!,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'عدد مرات البيع: ${product.soldCount}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    'السعر: ${product.price} جنيه مصرى',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          );
        } else if (state is ProductsMostSoldError) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'حدث خطأ: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}