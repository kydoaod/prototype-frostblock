import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tuya_flutter/tuya_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:wifi_iot/wifi_iot.dart'; // Import the wifi_iot package

class QRCodeScanner extends StatefulWidget {
  final ValueChanged<String> onQRCodeScanned; // Callback for scanned QR code

  const QRCodeScanner({
    super.key,
    required this.onQRCodeScanned, // Pass scanned QR data back
  });

  @override
  _QRCodeScannerState createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  bool _isScanComplete = false; // Track if the scan is complete
  bool isScanning = false;
  static const MethodChannel _channel = MethodChannel('tuya_flutter');
  List<Map<String, dynamic>> discoveredDevices = [];

  @override
  void initState() {
    super.initState();
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    if (call.method == "activatorCallback") {
      final Map<dynamic, dynamic> rawArgs = call.arguments;
      final String event = rawArgs["event"]?.toString() ?? "";
      print(rawArgs);
      if (event == "deviceFound") {
        setState(() {
          discoveredDevices.add({
            "device": rawArgs["device"]?.toString() ?? "",
            "devId": rawArgs["devId"]?.toString() ?? "",
          });
        });
      }
    }
  }

  void _startScan() async {
    setState(() {
      isScanning = true;
      discoveredDevices.clear();
    });

    try {
      const int homeId = 235518241;
      final tokenResult = await TuyaFlutter.getActivatorToken(homeId: homeId);
      print("Activator token: $tokenResult");
      final homeDetail = await TuyaFlutter.getDeviceList(homeId: homeId);
      print("Home Detail: $homeDetail");

      final buildResult = await TuyaFlutter.buildActivator(
        token: tokenResult ?? "",
        timeout: 100,
        ssid: "BAHAYSOLIS24G",
        password: "`1PLDTWIFIDBAPAa",
        model: "THING_AP"
      );
      print("Activator built: $buildResult");
      await TuyaFlutter.startActivator();

      // Stop scanning after 30 seconds if no pairing success
      Future.delayed(const Duration(seconds: 30), () {
        if (!_isScanComplete) {
          setState(() {
            _isScanComplete = true;
          });
          WiFiForIoTPlugin.forceWifiUsage(false);
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
      print("Scan stopped after 30 seconds");
    } catch (e) {
      print("Error stopping activator: $e");
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
              width: double.infinity, // Ensure it takes the full width
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
                          widget.onQRCodeScanned(barcode.rawValue!); 
                          _connectToWifi(barcode.rawValue!);
                        }
                      },
                    ),
            ),
          ),
        ),
      ],
    );
  }

  // Function to connect to the Wi-Fi network using the QR code string
  void _connectToWifi(String wifiString) async {
    // Example Wi-Fi string format: WIFI:T:nopass;S:SmartLife-63B8;;
    final wifiDetails = wifiString.split(';');
    String? ssid;
    String? password;
    String? securityType;

    // Extract SSID, password, and security type
    for (var detail in wifiDetails) {
      if (detail.startsWith('S:')) {
        ssid = detail.substring(2);
      } else if (detail.startsWith('P:')) {
        password = detail.substring(2);
      } else if (detail.startsWith('T:')) {
        securityType = detail.substring(2);
      }
    }

    // Attempt to connect to the Wi-Fi network
    if (ssid != null) {
      bool success = false;
      if (securityType == 'nopass' || securityType == null) {
        // If no password, connect to an open network
        success = await WiFiForIoTPlugin.connect(ssid, security: NetworkSecurity.NONE);
      } else {
        // If there is a password, attempt to connect with it
        if (password != null) {
          success = await WiFiForIoTPlugin.connect(ssid, password: password);
        }
      }
      WiFiForIoTPlugin.forceWifiUsage(true);
      // If successfully connected, set _isScanComplete to true
      if (success) {
        _startScan();
        print("Successfully connected to $ssid");
      } else {
        print("Failed to connect to Wi-Fi");
      }
    }
  }
}
