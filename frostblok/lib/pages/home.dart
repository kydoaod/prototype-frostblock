import 'package:flutter/material.dart';
import 'package:frostblok/widgets/weather_widgets.dart';
import 'package:frostblok/widgets/device_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List to keep track of added DeviceCards
  List<Widget> deviceCards = [];

  void _addNewDevice() {
    setState(() {
      deviceCards.add(
        DeviceCard(
          temperature: 29, // Example data
          location: 'Garden City, UT',
          status: 'Drains are Safe!',
          onToggle: () {
            // Define toggle functionality here
          },
        ),
      );
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
                // Weather Card widget
                const WeatherCard(
                  location: 'Garden City',
                  date: 'Sunday | Nov 14',
                  weatherDescription: 'Heavy rain',
                  temperature: 29,
                  windSpeed: '3.7 mph',
                  pressure: '1010 mbar',
                  chanceOfIce: '70%',
                  humidity: '83%',
                ),
                const SizedBox(height: 16),
                // Add New Device Button
                ElevatedButton(
                  onPressed: _addNewDevice,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Replaces 'primary'
                    foregroundColor: Colors.black, // Replaces 'onPrimary'
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
                const SizedBox(height: 16),
                // Display list of DeviceCards
                ...deviceCards,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
