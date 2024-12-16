import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_dashboard/core/constants/font_manger.dart';
import 'package:supabase_dashboard/core/constants/styles_manger.dart';
import 'package:supabase_dashboard/dashboard/data/models/order_model.dart';
import 'package:supabase_dashboard/dashboard/presentation/view/orders/widgets/order_details.dart';
import 'package:supabase_dashboard/dashboard/presentation/view_model/orders/orders_cubit.dart';
import 'package:intl/intl.dart' as intl;


  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'accepted':
        return Colors.green;
      case 'completed':
        return Colors.teal;
      case 'delivered':
        return Colors.indigo;
      case 'canceled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

DataRow buildOrderRow(BuildContext context, OrderModel order) {
    final ordersCubit = context.read<OrdersCubit>();
    final statusColor = _getStatusColor(order.status);
    
    return DataRow(
      cells: [
        DataCell(
          Text(
            order.id.substring(0, 8),
            style:getBoldStyle(fontFamily: FontConstant.cairo  , fontSize: FontSize.size14)
          ),
        ),
        DataCell(
          Text(
            order.name,
            style: getBoldStyle(fontFamily: FontConstant.cairo  , fontSize: FontSize.size14),
          ),
        ),
        DataCell(
          Text(
            order.phoneNumber ?? '-',
            style: getBoldStyle(fontFamily: FontConstant.cairo  , fontSize: FontSize.size14)
          ),
        ),
        DataCell(
          Text(
            '${intl.NumberFormat('#,##0.00').format(order.totalAmount)} جنيه',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: statusColor),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: order.status,
                icon: Icon(Icons.arrow_drop_down, color: statusColor),
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w500,
                ),
                items: [
                  'pending',
                  'processing',
                  'accepted', 
                  'completed',
                  'delivered',
                  'canceled',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      ordersCubit.getStatusText(value),
                      style: getBoldStyle(fontFamily: FontConstant.cairo  , fontSize: FontSize.size14 , color: _getStatusColor(value))
                      
                      
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    ordersCubit.updateOrderStatus(order.id, newValue);
                  }
                },
              ),
            ),
          ),
        ),
        DataCell(
          Text(
            intl.DateFormat('dd/MM/yyyy HH:mm').format(order.createdAt),
            style: getSemiBoldStyle(fontFamily: FontConstant.cairo  , fontSize: FontSize.size14),
          ),
        ),
        DataCell(
          IconButton(
            icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
            onPressed: () => showOrderDetails(context, order),
          ),
        ),
      ],
    );
  }