import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_dashboard/dashboard/data/models/product_model.dart';
import 'package:supabase_dashboard/dashboard/presentation/view/products/add_product_view.dart';
import 'package:supabase_dashboard/dashboard/presentation/view/products/edit_product_view.dart';

import 'package:supabase_dashboard/dashboard/presentation/view_model/categories/categories_cubit.dart';
import 'package:supabase_dashboard/dashboard/presentation/view_model/products/products_cubit.dart';

class ProductsView extends StatefulWidget {
  const ProductsView({super.key});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late final ProductsCubit _productsCubit;

  @override
  void initState() {
    super.initState();
    _productsCubit = ProductsCubit()..loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _productsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _productsCubit,
      child: BlocListener<ProductsCubit, ProductsState>(
        listener: (context, state) {
          if (state is ProductDeleteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم حذف المنتج بنجاح'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ProductAddSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم إضافة المنتج بنجاح'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ProductUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم تحديث المنتج بنجاح'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ProductsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('حدث خطأ: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Builder(
          builder: (context) => BlocBuilder<ProductsCubit, ProductsState>(
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('المنتجات'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MultiBlocProvider(
                              providers: [
                                BlocProvider.value(value: _productsCubit),
                                BlocProvider(
                                  create: (context) => CategoriesCubit()..loadCategories(),
                                ),
                              ],
                              child: const AddProductView(),
                            ),
                          ),
                        ).then((_) {
                          _productsCubit.loadProducts();
                        });
                      },
                    ),
                  ],
                ),
                body: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'بحث عن منتج...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      _searchController.clear();
                                      _searchQuery = '';
                                    });
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Theme.of(context).primaryColor),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value.toLowerCase();
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: _buildBody(context, state),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProductsState state) {
    if (state is ProductsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ProductsError) {
      return Center(child: Text('حدث خطأ: ${state.message}'));
    }

    if (state is ProductsFetched) {
      final products = state.products;
      final filteredProducts = products.where((product) {
        return product.name.toLowerCase().contains(_searchQuery) ||
            product.description.toLowerCase().contains(_searchQuery);
      }).toList();

      if (filteredProducts.isEmpty) {
        return const Center(
          child: Text('لا توجد منتجات متاحة'),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildProductCard(context, filteredProducts[index]),
        ),
      );
    }

    // Initial state
    _productsCubit.loadProducts();
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildProductCard(BuildContext context, ProductModel product) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: _productsCubit),
                  BlocProvider(
                    create: (context) => CategoriesCubit()..loadCategories(),
                  ),
                ],
                child: EditProductView(product: product),
              ),
            ),
          ).then((_) => _productsCubit.loadProducts());
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // صورة المنتج
              Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.network(
                  product.imageUrl!,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: const Row(
                                children: [
                                  Icon(Icons.edit, color: Colors.blue),
                                  SizedBox(width: 8),
                                  Text('تعديل'),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MultiBlocProvider(
                                      providers: [
                                        BlocProvider.value(value: _productsCubit),
                                        BlocProvider(
                                          create: (context) => CategoriesCubit()..loadCategories(),
                                        ),
                                      ],
                                      child: EditProductView(product: product),
                                    ),
                                  ),
                                ).then((_) => _productsCubit.loadProducts());
                              },
                            ),
                            PopupMenuItem(
                              child: const Row(
                                children: [
                                  Icon(Icons.add_shopping_cart),
                                  SizedBox(width: 8),
                                  Text('زيادة عدد مرات البيع'),
                                ],
                              ),
                              onTap: () async {
                                try {
                                  await _productsCubit.incrementSoldCount(product.id!);
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('تم تحديث عدد مرات البيع'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } catch (e) {
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('فشل في تحديث عدد مرات البيع: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                            ),
                            PopupMenuItem(
                              child: const Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('حذف'),
                                ],
                              ),
                              onTap: () {
                                Future.delayed(
                                  const Duration(seconds: 0),
                                  () => showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('حذف المنتج'),
                                      content: const Text('هل أنت متأكد من حذف هذا المنتج؟'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text('إلغاء'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            try {
                                              await _productsCubit.deleteProduct(product.id!);
                                            } catch (e) {
                                              if (!context.mounted) return;
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('فشل في حذف المنتج: $e'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          },
                                          child: const Text(
                                            'حذف',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description,
                      style: TextStyle(color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'السعر',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              Text(
                                '${product.price} ج.م',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'المخزون',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              Text(
                                '${product.stock} قطعة',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (product.hasDiscount)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'الخصم',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                Text(
                                  '${product.discountPercentage}%',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'عدد مرات البيع',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              Text(
                                '${product.soldCount} مرة',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
