import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frostblok/pages/home.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frostblok/services/app_service_config.dart';
import 'package:tuya_flutter/tuya_flutter.dart';
import 'package:permission_handler/permission_handler.dart';


void main() async {
  await dotenv.load(fileName: ".env");
  await requestBluetoothPermissions();
  runApp(const MyApp());
}

Future<void> requestBluetoothPermissions() async {
  // Request multiple permissions simultaneously.
  Map<Permission, PermissionStatus> statuses = await [
    Permission.bluetoothScan,
    Permission.bluetoothConnect,
    Permission.bluetoothAdvertise,
    Permission.location,
  ].request();

  // Optional: Check the statuses and print them.
  print("Bluetooth Scan: ${statuses[Permission.bluetoothScan]}");
  print("Bluetooth Connect: ${statuses[Permission.bluetoothConnect]}");
  print("Bluetooth Advertise: ${statuses[Permission.bluetoothAdvertise]}");
  print("Location: ${statuses[Permission.location]}");

  // Optional: Handle denied permissions if needed.
  if (statuses[Permission.bluetoothScan]?.isDenied == true ||
      statuses[Permission.bluetoothConnect]?.isDenied == true) {
    // You can show a dialog or take further action.
    print("Bluetooth permissions are denied.");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    // Initialize the Tuya SDK using the plugin.
    TuyaFlutter.initTuya(appKey:  AppConfig().tuyaAppKey, appSecret: AppConfig().tuyaAppSecret).then((result) {
      print("Init Result: $result");
      //_startListeningForMeshEvents();
      //testHomeAndToken();
    }).catchError((error) {
      print("Init Error: $error");
    });

    // Uncomment the following block if you want to test login as well.

    // TuyaFlutter.loginWithEmail(
    //   countryCode: "63",
    //   email: "",
    //   passwd: "",
    // ).then((result) {
    //   print("Login Result: $result");
    // }).catchError((error) {
    //   print("Login Error: $error");
    // });
  }

  String _status = "Idle";
  List<Map<dynamic, dynamic>> _discoveredDevices = [];

  // EventChannel for receiving mesh scan events from native side.
  static const EventChannel _meshEventChannel = EventChannel('tuya_flutter/meshScanCallback');

  void _startListeningForMeshEvents() {
    _meshEventChannel.receiveBroadcastStream().listen((dynamic event) {
      if (event is Map) {
        final String eventType = event['event'] ?? "";
        if (eventType == "deviceFound") {
          setState(() {
            _discoveredDevices.add(event);
            _status =
                "Device found: ${event['name']} (ID: ${event['devId']})";
          });
          print("Device found: ${event['name']}, ID: ${event['devId']}");
        } else if (eventType == "finished") {
          setState(() {
            _status = "Mesh scanning finished.";
          });
          print("Mesh scanning finished.");
        } else if (eventType == "error") {
          setState(() {
            _status = "Error during mesh scan: ${event['errorMsg']}";
          });
          print("Mesh scan error: ${event['errorMsg']}");
        } else if (eventType == "progress") {
          setState(() {
            _status = "Scan progress: ${event['step']}: ${event['data']}";
          });
          print("Scan progress: ${event['step']}: ${event['data']}");
        }
      }
    }, onError: (error) {
      print("Error receiving mesh events: $error");
    });
  }

  void testHomeAndToken() async {
    try {
      // Step 1: Create home and get homeId (or list of homes) from native.
      // final homeId = await TuyaFlutter.createHome(
      //   name: "San Pedro Home",
      //   lon: 121.041501,
      //   lat: 14.357762,
      //   geoName: "San Pedro, Laguna",
      //   rooms: ["Living Room"],
      // );
      // print("Home created with ID: $homeId");

      // Step 2: Get activator token with the homeId.
      
    // try {
    //   // Given homeId.
    //   const int homeId = 235518241;

    //   final meshList = await TuyaFlutter.getMeshList(homeId: homeId);
    //   String meshId;
    //   if (meshList == null || (meshList is List && meshList.isEmpty)) {
    //     print("No mesh found. Creating a new mesh...");
    //     // Step 2: Create a new mesh.
    //     meshId = await TuyaFlutter.createMesh(homeId: homeId, meshName: "MyMesh");
    //     print("Mesh created with ID: $meshId");
    //   } else {
    //     // Let the consuming app decide which mesh to use.
    //     // For this example, we simply pick the first mesh.
    //     meshId = meshList[0]['meshId'];
    //     print("Mesh exists. Using mesh ID: $meshId");
    //   }

    //   // Step 3: Initialize the mesh.
    //   final initResult = await TuyaFlutter.initMesh(meshId: meshId);
    //   print("Mesh initialized: $initResult");

    //   // Step 4: Start scanning for mesh devices.
    //   final scanResult = await TuyaFlutter.meshScanDevices(
    //     meshName: "out_of_mesh",
    //     meshId: meshId,
    //     timeout: 100
    //   );
    //   print("Mesh scan initiated: $scanResult");
    //   setState(() {
    //     _status = "Scanning for mesh devices...";
    //   });
    // } catch (e) {
    //   print("Error during mesh flow: $e");
    //   setState(() {
    //     _status = "Error: $e";
    //   });
    // }
      
      
      const int homeId = 235518241;
      final tokenResult = await TuyaFlutter.getActivatorToken(homeId: homeId);
      print("Activator token: $tokenResult");
      final homeDetail = await TuyaFlutter.getDeviceList(homeId: homeId);
      print("Home Detail: $homeDetail");

      // Step 3: Build the activator for scanning.
      // Omit ssid and password to use scanning-only mode, if supported.
      final buildResult = await TuyaFlutter.buildActivator(
        token: tokenResult??"",
        timeout: 100,
        ssid: "",
        password: ""
        // Do not pass ssid and password if you want scanning only.
      );
      print("Activator built: $buildResult");

      // Step 4: Start the activator (scanning process).
      //final startResult = await TuyaFlutter.startActivator();
      //print("Activator started: $startResult");

      // The native side should forward scan events (like discovered devices)
      // via callbacks (e.g., through an EventChannel or additional method channel calls).
      
    } catch (e) {
      print("Error during scanning: $e");
    }
  }

  final List<Widget> _pages = [
    const HomePage(), // Your existing HomePage
    const PlaceholderWidget(text: 'Devices'),
    const PlaceholderWidget(text: 'Settings'),
    const PlaceholderWidget(text: 'Profile'),
  ];

  void _onItemTapped(int index) {
    testHomeAndToken();
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        unselectedFontSize: 0,
        items: [
          _buildBottomNavigationBarItem(Icons.home, "Home", 0),
          _buildBottomNavigationBarItem(Icons.devices, "Devices", 1),
          _buildBottomNavigationBarItem(Icons.settings, "Settings", 2),
          _buildBottomNavigationBarItem(Icons.person, "Profile", 3),
        ],
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: _selectedIndex == index
          ? Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 24),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            )
          : Icon(icon, size: 24),
      label: '',
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final String text;
  const PlaceholderWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
