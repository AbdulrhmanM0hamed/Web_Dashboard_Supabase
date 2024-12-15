import 'package:flutter/material.dart';
import 'package:supabase_dashboard/core/constants/font_manger.dart';
import 'package:supabase_dashboard/core/constants/styles_manger.dart';
import 'package:supabase_dashboard/dashboard/data/models/order_model.dart';
import 'package:supabase_dashboard/dashboard/presentation/view/orders/widgets/order_row.dart';

Widget buildOrdersList(BuildContext context, List<OrderModel> orders) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الطلبات',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(
                    Colors.grey[50],
                  ),
                  dataRowMaxHeight: 80,
                  columnSpacing: 20,
                  columns:  [
                    DataColumn(
                      label: Text(
                        'رقم الطلب',
                        style:  getBoldStyle(fontFamily: FontConstant.cairo  , fontSize: FontSize.size16),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'اسم العميل',
                        style: getBoldStyle(fontFamily: FontConstant.cairo  , fontSize: FontSize.size16),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'رقم الهاتف',
                        style: getBoldStyle(fontFamily: FontConstant.cairo  , fontSize: FontSize.size16),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'المبلغ الإجمالي',
                        style: getBoldStyle(fontFamily: FontConstant.cairo  , fontSize: FontSize.size16),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'الحالة',
                        style: getBoldStyle(fontFamily: FontConstant.cairo  , fontSize: FontSize.size16),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'تاريخ الطلب',
                        style:getBoldStyle(fontFamily: FontConstant.cairo  , fontSize: FontSize.size16),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'الإجراءات',
                        style: getBoldStyle(fontFamily: FontConstant.cairo  , fontSize: FontSize.size16),
                      ),
                    ),
                  ],
                  rows: orders.map((order) => buildOrderRow(context, order)).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }