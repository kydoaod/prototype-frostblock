import 'package:flutter/material.dart';
import 'package:frostblok/widgets/weather_widgets.dart';
import 'package:frostblok/widgets/device_widget.dart';
import 'package:frostblok/pages/defrost_device.dart';  // Import DefrostDevicePage

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> weatherData = [
    {
      'location': 'Garden City',
      'date': 'Sunday | Nov 14',
      'weatherDescription': 'Heavy rain',
      'temperature': 29,
      'windSpeed': '3.7 mph',
      'pressure': '1010 mbar',
      'chanceOfIce': '70%',
      'humidity': '83%',
    }
  ];

  List<Widget> deviceCards = [
    DeviceCard(
      temperature: 29,
      location: 'Garden City, UT',
      status: 'Drains are Safe!',
      onToggle: () {},
      onTap: (context) {
        // Pass context here to navigate
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DefrostDevicePage()),
        );
      },
    )
  ];

  void _addNewDevice() {
    setState(() {
      deviceCards.add(
        DeviceCard(
          temperature: 30,
          location: 'New Location ${deviceCards.length + 1}',
          status: 'Drains are Safe!',
          onToggle: () {},
          onTap: (context) {
            // Navigate onTap with context
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DefrostDevicePage()),
            );
          },
        ),
      );

      weatherData.add({
        'location': 'New Location ${weatherData.length + 1}',
        'date': 'Monday | Nov 15',
        'weatherDescription': 'Cloudy',
        'temperature': 30,
        'windSpeed': '4.0 mph',
        'pressure': '1015 mbar',
        'chanceOfIce': '50%',
        'humidity': '75%',
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                WeatherCard(weatherData: weatherData),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _addNewDevice,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 2,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add),
                        SizedBox(width: 8),
                        Text('Add New Device'),
                      ],
                    ),
                  ),
                ),
                ...deviceCards,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
