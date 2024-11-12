import 'package:flutter/material.dart';
import 'package:frostblok/widgets/weather_widgets.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
              // Carousel Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    width: 8.0,
                    height: 8.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == 0 ? Colors.blueAccent : Colors.grey,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              // Add New Device Button
              ElevatedButton(
                onPressed: () {},
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
            ],
          ),
        ),
      ),
    );
  }
}
