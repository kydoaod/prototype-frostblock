import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tuya_flutter/tuya_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRCodeScanner extends StatefulWidget {
  final ValueChanged<String> onQRCodeScanned;
  final ValueChanged<Map<String, dynamic>> onDeviceSelected;

  const QRCodeScanner({
    super.key,
    required this.onQRCodeScanned,
    required this.onDeviceSelected
  });

  @override
  _QRCodeScannerState createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  bool _isScanComplete = false;
  bool _scanSuccess = false;
  bool isScanning = false;
  static const MethodChannel _channel = MethodChannel('tuya_flutter');
  List<Map<String, dynamic>> discoveredDevices = [];
  String? scannedQRValue;

  @override
  void initState() {
    super.initState();
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    if (call.method == "activatorCallback") {
      final Map<dynamic, dynamic> rawArgs = call.arguments;
      final String event = rawArgs["event"]?.toString() ?? "";
      print("activatorCallback");
      print(rawArgs);

      if (event == "deviceFound") {
        final String device = rawArgs["device"]?.toString() ?? "";
        final String devId = rawArgs["devId"]?.toString() ?? "";

        print("Found device: $device");
        print("Looking for: $scannedQRValue");

        if (device == scannedQRValue) {
          setState(() {
            discoveredDevices.add({
              "device": device,
              "devId": devId,
            });
            _scanSuccess = true;
            _isScanComplete = true;
            widget.onDeviceSelected(discoveredDevices[0]);
          });
          _stopScan();
        } else {
          try {
            await _channel.invokeMethod('resetFactory', {'devId': devId});
            print("Called resetFactory on $devId");
          } catch (e) {
            print("Error calling resetFactory: $e");
          }
        }
      }
    }
  }

  void _startScan() async {
    setState(() {
      isScanning = true;
      discoveredDevices.clear();
      _scanSuccess = false;
      _isScanComplete = false;
    });

    try {
      const int homeId = 235518241;
      final tokenResult = await TuyaFlutter.getActivatorToken(homeId: homeId);
      print("Activator token: $tokenResult");

      final buildResult = await TuyaFlutter.buildActivator(
        token: tokenResult ?? "",
        timeout: 100,
        ssid: "BAHAYSOLIS24G",
        password: "`1PLDTWIFIDBAPAa",
        model: "THING_EZ",
      );
      print("Activator built: $buildResult");

      await TuyaFlutter.startActivator();

      // Timeout after 100s if no match
      Future.delayed(const Duration(seconds: 100), () {
        if (!_scanSuccess) {
          setState(() {
            _isScanComplete = true;
          });
          _stopScan();
        }
      });
    } catch (e) {
      print("Error starting activator: $e");
    }
  }

  void _stopScan() async {
    try {
      await TuyaFlutter.stopActivator();
      setState(() {
        isScanning = false;
      });
      print("Scan stopped.");
    } catch (e) {
      print("Error stopping activator: $e");
    }
  }

  Widget _buildScannerView() {
    return MobileScanner(
      onDetect: (BarcodeCapture barcodeCapture) {
        final barcode = barcodeCapture.barcodes.first;
        if (barcode.rawValue != null && scannedQRValue == null) {
          final value = barcode.rawValue!;
          setState(() {
            scannedQRValue = value;
          });
          widget.onQRCodeScanned(value);
          _startScan();
        }
      },
    );
  }

  Widget _buildStatusView() {
    if (isScanning && !_isScanComplete) {
      return const Center(child: CircularProgressIndicator());
    } else if (_isScanComplete && _scanSuccess) {
      return const Center(
        child: Text(
          "Scan complete. Device matched!",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    } else if (_isScanComplete && !_scanSuccess) {
      return const Center(
        child: Text(
          "Scan failed. No matching device found.",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
        ),
      );
    } else {
      return _buildScannerView();
    }
  }

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
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.7,
              child: _buildStatusView(),
            ),
          ),
        ),
      ],
    );
  }
}
