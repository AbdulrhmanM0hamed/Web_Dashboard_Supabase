import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_dashboard/dashboard/presentation/view/special_offers/add_special_offer_view.dart';
import 'package:supabase_dashboard/dashboard/presentation/view/special_offers/edit_special_offer_view.dart';
import 'package:supabase_dashboard/dashboard/presentation/view_model/special_offers/special_offers_cubit.dart';

class SpecialOffersView extends StatefulWidget {
  const SpecialOffersView({super.key});

  @override
  State<SpecialOffersView> createState() => _SpecialOffersViewState();
}

class _SpecialOffersViewState extends State<SpecialOffersView> {
  @override
  void initState() {
    super.initState();
    context.read<SpecialOffersCubit>().loadSpecialOffers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('العروض الخاصة'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => SpecialOffersCubit(),
                    child: const AddSpecialOfferView(),
                  ),
                ),
              );
              // إذا تمت الإضافة بنجاح، قم بتحديث القائمة
              if (result == true) {
                if (context.mounted) {
                  await context.read<SpecialOffersCubit>().loadSpecialOffers();
                }
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<SpecialOffersCubit, SpecialOffersState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'حدث خطأ: ${state.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SpecialOffersCubit>().loadSpecialOffers();
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          if (state.offers.isEmpty) {
            return const Center(
              child: Text('لا توجد عروض خاصة'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.offers.length,
            itemBuilder: (context, index) {
              final offer = state.offers[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (offer.image1 != null)
                      Image.network(
                        offer.image1!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      offer.title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(offer.subtitle),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BlocProvider(
                                            create: (context) => SpecialOffersCubit(),
                                            child: EditSpecialOfferView(offer: offer),
                                          ),
                                        ),
                                      );
                                      
                                      if (result == true && context.mounted) {
                                        context.read<SpecialOffersCubit>().loadSpecialOffers();
                                      }
                                    },
                                  ),
                                  Switch(
                                    value: offer.isActive,
                                    onChanged: (value) {
                                      context
                                          .read<SpecialOffersCubit>()
                                          .toggleSpecialOfferStatus(offer.id!, value);
                                    },
                                  ),
                                  IconButton(
                                    icon:
                                        const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      final confirmed = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('حذف العرض'),
                                          content: const Text(
                                              'هل أنت متأكد من حذف هذا العرض؟'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, false),
                                              child: const Text('إلغاء'),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, true),
                                              child: const Text('حذف'),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (confirmed == true) {
                                        await context
                                            .read<SpecialOffersCubit>()
                                            .deleteSpecialOffer(offer.id!);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
