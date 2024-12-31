import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_dashboard/core/constants/colors.dart';
import 'package:supabase_dashboard/core/constants/font_manger.dart';
import 'package:supabase_dashboard/core/constants/styles_manger.dart';
import 'package:supabase_dashboard/dashboard/presentation/view/orders/widgets/build_Detail_row.dart';
import 'package:supabase_dashboard/dashboard/presentation/view/orders/widgets/order_list_view.dart';
import 'package:supabase_dashboard/dashboard/presentation/view/orders/widgets/show_order_Details.dart';
import '../../view_model/orders/orders_cubit.dart';
import '../../../data/models/order_model.dart';


class OrdersView extends StatefulWidget {
  const OrdersView({super.key});

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  @override
  void initState() {
    super.initState();
    context.read<OrdersCubit>().loadOrders();
  }



  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          if (state is OrdersLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrdersError) {
            return Center(child: Text('خطأ: ${state.message}'));
          } else if (state is OrdersLoaded) {
            return buildOrdersList(context, state.orders);
          }
          return const SizedBox();
        },
      ),
    );
  }

 

  

  void showOrderDetails(BuildContext context, OrderModel order) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'تفاصيل الطلب #${order.id.substring(0, 8)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.print, color: Colors.blue),
                        onPressed: () => printInvoice(context, order),
                        tooltip: 'طباعة الفاتورة',
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(height: 24),
              buildDetailRow('العميل', order.name),
              buildDetailRow('رقم الهاتف', order.phoneNumber ?? '-'),
              buildDetailRow('العنوان', order.deliveryAddress ?? '-'),
              const SizedBox(height: 16),
              const Text(
                'المنتجات',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...order.items.map((item) => Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(item.productName),
                      subtitle: Text('${item.quantity} × ${item.price} ريال'),
                      trailing: Text(
                        '${item.quantity * item.price} ريال',
                        style: getBoldStyle(fontFamily: FontConstant.cairo  , fontSize: FontSize.size14 , color: TColors.primary),
                      ),
                    ),
                  )),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'الإجمالي',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${order.totalAmount} ريال',
                    style: getBoldStyle(fontFamily: FontConstant.cairo  , fontSize: FontSize.size18 , color: TColors.secondary),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }



}
