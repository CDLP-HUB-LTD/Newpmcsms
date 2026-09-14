import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ReceiptGenerator {
  static Future<Uint8List> build({
    required String title,
    required String amount,
    required bool isCredit,
    required String categoryLabel,
    required String transactionId,
    required String status,
    required String transactionDate,
    required String category,
    String? counterpartyLabel,
    String? counterpartyName,
    String? extraLabel,
    String? extraValue,
  }) async {
    final doc = pw.Document();

    final regularData =
        await rootBundle.load('assets/fonts/NotoSans-Regular.ttf');
    final boldData = await rootBundle.load('assets/fonts/NotoSans-Bold.ttf');
    final regularFont = pw.Font.ttf(regularData);
    final boldFont = pw.Font.ttf(boldData);

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        theme: pw.ThemeData.withFont(
          base: regularFont,
          bold: boldFont,
        ),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Transaction Receipt',
                style:
                    pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                DateTime.now().toString(),
                style:
                    const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
              ),
              pw.Divider(height: 32),
              pw.Text(title, style: const pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 4),
              pw.Text(
                '${isCredit ? '+' : '-'}$amount',
                style:
                    pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 2),
              pw.Text(categoryLabel,
                  style: const pw.TextStyle(color: PdfColors.grey600)),
              pw.SizedBox(height: 24),
              _row('Transaction ID', transactionId),
              _row('Status', status),
              _row('Transaction Date', transactionDate),
              if (counterpartyLabel != null && counterpartyName != null)
                _row(counterpartyLabel, counterpartyName),
              if (extraLabel != null && extraValue != null)
                _row(extraLabel, extraValue),
              _row('Category', category),
              pw.SizedBox(height: 40),
              pw.Divider(),
              pw.SizedBox(height: 8),
              pw.Text(
                'This is a system-generated receipt.',
                style:
                    const pw.TextStyle(fontSize: 9, color: PdfColors.grey500),
              ),
            ],
          );
        },
      ),
    );

    return doc.save();
  }

  static pw.Widget _row(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: const pw.TextStyle(color: PdfColors.grey600)),
          pw.Text(value, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }
}
