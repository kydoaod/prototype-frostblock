import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothService {
  final FlutterBluePlus flutterBlue = FlutterBluePlus.instance;

  // Initialize Bluetooth and ensure permissions are granted
  Future<void> initializeBluetooth() async {
    // Check Bluetooth state
    final bluetoothState = await flutterBlue.state.first;
    if (bluetoothState != BluetoothState.on) {
      print('Bluetooth is not enabled. Please enable it.');
    }

    // Request permissions if required
    final isAvailable = await flutterBlue.isAvailable;
    final isOn = await flutterBlue.isOn;

    if (!isAvailable || !isOn) {
      throw Exception('Bluetooth is not available or enabled.');
    }
  }

  // Start scanning for devices
  Stream<ScanResult> startScan({Duration timeout = const Duration(seconds: 5)}) {
    flutterBlue.startScan(timeout: timeout);
    return flutterBlue.scanResults.expand((results) => results);
  }

  // Stop scanning for devices
  Future<void> stopScan() async {
    await flutterBlue.stopScan();
  }

  // Connect to a selected device
  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect(autoConnect: false);
      print('Connected to device: ${device.name}');
    } catch (e) {
      print('Error connecting to device: $e');
    }
  }

  // Disconnect from a connected device
  Future<void> disconnectFromDevice(BluetoothDevice device) async {
    try {
      await device.disconnect();
      print('Disconnected from device: ${device.name}');
    } catch (e) {
      print('Error disconnecting from device: $e');
    }
  }

  // Discover services and characteristics
  Future<void> discoverServices(BluetoothDevice device) async {
    final services = await device.discoverServices();
    for (var service in services) {
      print('Service UUID: ${service.uuid}');
      for (var characteristic in service.characteristics) {
        print('Characteristic UUID: ${characteristic.uuid}');
      }
    }
  }

  // Write data to a characteristic
  Future<void> writeCharacteristic(
      BluetoothCharacteristic characteristic, List<int> value,
      {bool withoutResponse = false}) async {
    try {
      await characteristic.write(value, withoutResponse: withoutResponse);
      print('Data written to characteristic: $value');
    } catch (e) {
      print('Error writing to characteristic: $e');
    }
  }

  // Read data from a characteristic
  Future<List<int>> readCharacteristic(
      BluetoothCharacteristic characteristic) async {
    try {
      final value = await characteristic.read();
      print('Data read from characteristic: $value');
      return value;
    } catch (e) {
      print('Error reading from characteristic: $e');
      return [];
    }
  }

  // Subscribe to notifications for a characteristic
  Future<void> setNotification(
      BluetoothCharacteristic characteristic, bool enable) async {
    try {
      await characteristic.setNotifyValue(enable);
      characteristic.value.listen((value) {
        print('Notification from characteristic: $value');
      });
      print(
          'Notifications ${enable ? 'enabled' : 'disabled'} for characteristic');
    } catch (e) {
      print('Error setting notification: $e');
    }
  }
}
