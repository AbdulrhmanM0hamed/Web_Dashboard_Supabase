import 'package:pdf/widgets.dart' as pw;

pw.Widget buildInfoRow(
    String label, String value, pw.Font regularFont, pw.Font boldFont) {
  return pw.Container(
    margin: const pw.EdgeInsets.symmetric(vertical: 2),
    child: pw.Row(
      children: [
        pw.Text(
          '$label: ',
          style: pw.TextStyle(
            font: boldFont,
            fontSize: 10,
          ),
        ),
        pw.Expanded(
          child: pw.Text(
            value,
            style: pw.TextStyle(
              font: regularFont,
              fontSize: 10,
            ),
          ),
        ),
      ],
    ),
  );
}
