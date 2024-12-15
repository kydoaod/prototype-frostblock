import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRCodeScanner extends StatefulWidget {
  final ValueChanged<String> onQRCodeScanned; // Callback for scanned QR code

  const QRCodeScanner({
    Key? key,
    required this.onQRCodeScanned, // Pass scanned QR data back
  }) : super(key: key);

  @override
  _QRCodeScannerState createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  bool _isScanComplete = false; // Track if the scan is complete

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: SizedBox(
              width: double.infinity,  // Ensure it takes the full width
              height: MediaQuery.of(context).size.height * 0.7, // Take 80% of the screen height
              child: _isScanComplete
                  ? const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Scan complete, please tap next", // Display completion message
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : MobileScanner(
                      onDetect: (BarcodeCapture barcodeCapture) {
                        final barcode = barcodeCapture.barcodes.first;
                        if (barcode.rawValue != null && !_isScanComplete) {
                          setState(() {
                            _isScanComplete = true;
                          });
                          widget.onQRCodeScanned(barcode.rawValue!); // Send scanned data back
                        }
                      },
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
