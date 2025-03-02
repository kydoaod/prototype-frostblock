import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tuya_flutter/tuya_flutter.dart';

class EzDeviceSelector extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>> onDeviceSelected;

  const EzDeviceSelector({super.key, required this.onDeviceSelected});

  @override
  _EzDeviceSelectorState createState() => _EzDeviceSelectorState();
}

class _EzDeviceSelectorState extends State<EzDeviceSelector> {
  static const MethodChannel _channel = MethodChannel('tuya_flutter');
  List<Map<String, dynamic>> discoveredDevices = [];
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    if (call.method == "activatorCallback") {
      // Cast raw arguments bilang Map<dynamic, dynamic>
      final Map<dynamic, dynamic> rawArgs = call.arguments;
      // Kunin ang event bilang string gamit ang toString()
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
        token: tokenResult??"",
        timeout: 100,
        ssid: "BAHAYSOLIS24G",
        password: "`1PLDTWIFIDBAPAa"
      );
      print("Activator built: $buildResult");
      await TuyaFlutter.startActivator();
    } catch (e) {
      print("Error starting activator: $e");
    }
  }

  void _stopScan() async {
    try {
      await TuyaFlutter.stopActivator();
    } catch (e) {
      print("Error stopping activator: $e");
    }
    setState(() {
      isScanning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Discovered Tuya Devices",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton(
            onPressed: isScanning ? _stopScan : _startScan,
            child: Text(isScanning ? "Stop Scan" : "Start Scan"),
          ),
        ),
        if (isScanning)
          const Center(child: CircularProgressIndicator()),
        Expanded(
          child: ListView.builder(
            itemCount: discoveredDevices.length,
            itemBuilder: (context, index) {
              final device = discoveredDevices[index];
              return ListTile(
                title: Text(device["device"] ?? "Unnamed Device"),
                subtitle: Text("Device ID: ${device["devId"]}"),
                onTap: () => widget.onDeviceSelected(device),
              );
            },
          ),
        ),
      ],
    );
  }
}
