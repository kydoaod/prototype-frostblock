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

  final List<Widget> _pages = [
    const HomePage(), // Your existing HomePage
    const PlaceholderWidget(text: 'Devices'),
    const PlaceholderWidget(text: 'Settings'),
    const PlaceholderWidget(text: 'Profile'),
  ];

  void _onItemTapped(int index) {
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
