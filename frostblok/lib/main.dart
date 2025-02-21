import 'package:flutter/material.dart';
import 'package:frostblok/pages/home.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frostblok/services/app_service_config.dart';
import 'package:tuya_flutter/tuya_flutter.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
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

  void testHomeAndToken() async {
    try {
      // Step 1: Create home and get homeId (or list of homes) from native.
      final homeId = await TuyaFlutter.createHome(
        name: "San Pedro Home",
        lon: 121.041501,
        lat: 14.357762,
        geoName: "San Pedro, Laguna",
        rooms: ["Living Room"],
      );
      print("Home created with ID: $homeId");

      // Step 2: Get activator token with the homeId.
      final tokenResult = await TuyaFlutter.getActivatorToken(homeId: homeId);
      print("Activator token: $tokenResult");

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
      final startResult = await TuyaFlutter.startActivator();
      print("Activator started: $startResult");

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
