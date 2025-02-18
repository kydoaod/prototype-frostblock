import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:frostblok/services/bluetooth_wrapper_service.dart';

class BluetoothSelector extends StatefulWidget {
  final ValueChanged<BluetoothDevice> onDeviceSelected;

  const BluetoothSelector({super.key, required this.onDeviceSelected});

  @override
  _BluetoothSelectorState createState() => _BluetoothSelectorState();
}

class _BluetoothSelectorState extends State<BluetoothSelector> {
  final BluetoothWrapperService bluetoothService = BluetoothWrapperService();
  List<ScanResult> scanResults = [];
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
  }

  // Start scanning for Bluetooth devices
  void _toggleScan() async {
    if (isScanning) {
      await bluetoothService.stopScan();
    } else {
      setState(() {
        isScanning = true;
      });

      // Initialize Bluetooth and check for its state
      await bluetoothService.initializeBluetooth();

      // Start scanning for devices
      bluetoothService.startScan(timeout: const Duration(seconds: 30)).listen((results) {
        setState(() {
          scanResults = results;
        });
      });

      // Stop scanning after a timeout
      await Future.delayed(const Duration(seconds: 30));
      await bluetoothService.stopScan();
      setState(() {
        isScanning = false;
      });
    }
  }

  void onSelectDevice(device) {
    widget.onDeviceSelected(device); // Pass selected device to parent widget
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Select Bluetooth Device:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),

        // Toggle to start/stop scanning
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ElevatedButton(
            onPressed: _toggleScan,
            child: Text(isScanning ? 'Stop Scanning' : 'Start Scanning'),
          )
        ),

        // Show scanning indicator
        if (isScanning) 
          const Center(child: CircularProgressIndicator()),

        // List of scanned Bluetooth devices
        Expanded(
          child: ListView.builder(
            itemCount: scanResults.length,
            itemBuilder: (context, index) {
              final device = scanResults[index].device;
              return ListTile(
                title: Text(device.name.isNotEmpty ? device.name : 'Unnamed Device'),
                onTap: () => onSelectDevice(device),
              );
            },
          ),
        ),
      ],
    );
  }
}
