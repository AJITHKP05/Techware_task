import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({super.key, required this.onDetect});
  final Function(String?) onDetect;
  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  bool viewQRScanner = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close))
        ],
      ),
      body: MobileScanner(
        // fit: BoxFit.contain,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            debugPrint('Barcode found! ${barcode.rawValue}');
            if (barcode.rawValue is String) {
              
              if (viewQRScanner && barcode.rawValue is String) {
                viewQRScanner = false;
                widget.onDetect(barcode.rawValue);
                Navigator.pop(context);
              }
              setState(() {});
            }
          }
        },
      ),
    );
  }
}
