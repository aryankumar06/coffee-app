import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// Color Palette
const Color textPrimary = Color(0xFF30364F); // Dark Blue/Navy
const Color primaryAccent = Color(0xFFACBAC4); // Light Blue/Greyish
const Color secondaryAccent = Color(0xFFE1D9BC); // Beige/Sand
const Color backgroundLight = Color(0xFFF0F0DB); // Light Beige/Off-white

class QrGeneratorScreen extends StatefulWidget {
  const QrGeneratorScreen({super.key});

  @override
  State<QrGeneratorScreen> createState() => _QrGeneratorScreenState();
}

class _QrGeneratorScreenState extends State<QrGeneratorScreen> {
  final TextEditingController _seatController = TextEditingController();
  int _generatedCount = 0;
  final String _cafeId = "KlubEats-Cafe-123";

  @override
  void dispose() {
    _seatController.dispose();
    super.dispose();
  }

  void _generateQRCodes() {
    if (_seatController.text.isNotEmpty) {
      int? count = int.tryParse(_seatController.text);
      if (count != null && count > 0) {
        setState(() {
          _generatedCount = count;
        });
        // Hide keyboard
        FocusScope.of(context).unfocus();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid number of seats.', style: TextStyle(color: backgroundLight)), backgroundColor: textPrimary),
        );
      }
    }
  }

  String _buildQrData(int tableNum) {
    // encodes: { cafe_id, table_number } as a deep link URL
    return "https://app.klubeats.com/order?cafe=$_cafeId&table=$tableNum";
  }

  Future<void> _exportPdf() async {
    if (_generatedCount <= 0) return;

    final pdf = pw.Document();

    // Iterate through all table numbers and generate a page for each QR code
    // We use a simple 1 QR / page layout for print-ready tables
    for (int i = 1; i <= _generatedCount; i++) {
      final qrData = _buildQrData(i);
      
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    "Scan to Order",
                    style: pw.TextStyle(
                      fontSize: 40,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 40),
                  pw.BarcodeWidget(
                    barcode: pw.Barcode.qrCode(),
                    data: qrData,
                    width: 300,
                    height: 300,
                  ),
                  pw.SizedBox(height: 40),
                  pw.Text(
                    "Table $i",
                    style: pw.TextStyle(
                      fontSize: 60,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    "KLUB EATS",
                    style: pw.TextStyle(
                      fontSize: 24,
                      color: PdfColors.grey700,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }

    // Print or Share the PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Cafe_Table_QRCodes.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: const Text('QR Code Generator', style: TextStyle(fontWeight: FontWeight.bold, color: backgroundLight)),
        backgroundColor: textPrimary,
        iconTheme: const IconThemeData(color: backgroundLight),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryAccent.withOpacity(0.5)),
                boxShadow: [
                  BoxShadow(
                    color: textPrimary.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Generate Table QR Codes",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Enter the total number of physical tables/seats in your cafe.",
                    style: TextStyle(color: primaryAccent),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _seatController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Number of Tables",
                            labelStyle: const TextStyle(color: textPrimary),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: primaryAccent),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: textPrimary, width: 2),
                            ),
                            filled: true,
                            fillColor: backgroundLight.withOpacity(0.5),
                            prefixIcon: const Icon(Icons.table_restaurant, color: textPrimary),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _generateQRCodes,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: textPrimary,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Generate", style: TextStyle(color: backgroundLight, fontSize: 16)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Preview Area Header
            if (_generatedCount > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Preview ($_generatedCount Tables)",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _exportPdf,
                    icon: const Icon(Icons.picture_as_pdf, color: backgroundLight, size: 18),
                    label: const Text("Export PDF", style: TextStyle(color: backgroundLight)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            
            const SizedBox(height: 12),

            // Grid Preview
            if (_generatedCount > 0)
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: _generatedCount,
                  itemBuilder: (context, index) {
                    final tableNum = index + 1;
                    final qrData = _buildQrData(tableNum);
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: primaryAccent.withOpacity(0.3)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          QrImageView(
                            data: qrData,
                            version: QrVersions.auto,
                            size: 120.0,
                            backgroundColor: Colors.white,
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            decoration: BoxDecoration(
                              color: secondaryAccent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "Table $tableNum",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            else
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.qr_code_scanner, size: 80, color: primaryAccent),
                      SizedBox(height: 16),
                      Text(
                        "Input the number of tables\nto generate QR codes.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: textPrimary, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
