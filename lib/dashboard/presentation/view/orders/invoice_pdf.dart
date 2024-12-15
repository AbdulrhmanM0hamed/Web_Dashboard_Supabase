import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:supabase_dashboard/dashboard/presentation/view/orders/widgets/build_Info_row.dart';
import '../../../data/models/order_model.dart';
import 'package:intl/intl.dart' as intl;

class InvoicePDF {
  static Future<Uint8List> generate(OrderModel order) async {
    final pdf = pw.Document();

    final fontData = await rootBundle.load('assets/fonts/Cairo-Regular.ttf');
    final arabicFont = pw.Font.ttf(fontData);

    final boldFontData = await rootBundle.load('assets/fonts/Cairo-Bold.ttf');
    final arabicBoldFont = pw.Font.ttf(boldFontData);

    const receiptPageFormat = PdfPageFormat(
      80 * PdfPageFormat.mm,
      double.infinity,
      marginAll: 5 * PdfPageFormat.mm,
    );

    pdf.addPage(
      pw.Page(
        textDirection: pw.TextDirection.rtl,
        pageFormat: receiptPageFormat,
        theme: pw.ThemeData.withFont(
          base: arabicFont,
          bold: arabicBoldFont,
        ),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              // Header
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(vertical: 5),
                child: pw.Column(
                  children: [
                    pw.Text(
                      'فاتورة',
                      style: pw.TextStyle(
                        font: arabicBoldFont,
                        fontSize: 16,
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      'رقم #${order.id.substring(0, 8)}',
                      style: pw.TextStyle(
                        font: arabicFont,
                        fontSize: 10,
                      ),
                    ),
                    pw.Text(
                      intl.DateFormat('dd/MM/yyyy HH:mm')
                          .format(order.createdAt),
                      style: pw.TextStyle(
                        font: arabicFont,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),

              // Customer Info Section
              pw.Container(
                width: double.infinity,
                padding:
                    const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'معلومات العميل',
                      style: pw.TextStyle(
                        font: arabicBoldFont,
                        fontSize: 14,
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    buildInfoRow(
                        'الاسم', order.name, arabicFont, arabicBoldFont),
                    buildInfoRow('الهاتف', order.phoneNumber ?? '-', arabicFont,
                        arabicBoldFont),
                    buildInfoRow('العنوان', order.deliveryAddress ?? '-',
                        arabicFont, arabicBoldFont),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),

              // Items Header
              pw.Container(
                width: double.infinity,
                padding:
                    const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 3,
                      child: pw.Text(
                        'الصنف',
                        style: pw.TextStyle(
                          font: arabicBoldFont,
                          fontSize: 9,
                        ),
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Text(
                        'الكمية',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          font: arabicBoldFont,
                          fontSize: 8,
                        ),
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Text(
                        'السعر',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          font: arabicBoldFont,
                          fontSize: 8,
                        ),
                      ),
                    ),
                    
                    pw.Expanded(
                      child: pw.Text(
                        'الإجمالي',
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(
                          font: arabicBoldFont,
                          fontSize: 8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              pw.Divider(thickness: 0.5),

              // Items
              ...order.items.map((item) => pw.Column(
                    children: [
                      pw.Row(
                        children: [
                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              item.productName,
                              style:
                                  pw.TextStyle(font: arabicFont, fontSize: 8),
                            ),
                          ),
                          pw.Expanded(
                            child: pw.Text(
                              '${item.quantity}',
                              textAlign: pw.TextAlign.center,
                              style:
                                  pw.TextStyle(font: arabicFont, fontSize: 8),
                            ),
                          ),
                          pw.Expanded(
                            child: pw.Text(
                              '${item.price}',
                              textAlign: pw.TextAlign.center,
                              style:
                                  pw.TextStyle(font: arabicFont, fontSize: 8),
                            ),
                          ),
                          pw.Expanded(
                            child: pw.Text(
                              '${item.quantity * item.price} جنيه',
                              textAlign: pw.TextAlign.left,
                              style:
                                  pw.TextStyle(font: arabicFont, fontSize: 8),
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 2),
                    ],
                  )),

              pw.Divider(thickness: 0.5),

              // Total
              pw.Container(
                width: double.infinity,
                padding:
                    const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'الإجمالي:',
                      style: pw.TextStyle(
                        font: arabicBoldFont,
                        fontSize: 14,
                      ),
                    ),
                    pw.Text(
                      '${order.totalAmount} جنيه',
                      style: pw.TextStyle(
                        font: arabicBoldFont,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),

              // Footer
              pw.Center(
                child: pw.Text(
                  'شكراً لتعاملكم معنا',
                  style: pw.TextStyle(
                    font: arabicFont,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
