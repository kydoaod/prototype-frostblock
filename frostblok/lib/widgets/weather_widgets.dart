import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final String location;
  final String date;
  final String weatherDescription;
  final int temperature;
  final String windSpeed;
  final String pressure;
  final String chanceOfIce;
  final String humidity;

  const WeatherCard({
    super.key,
    required this.location,
    required this.date,
    required this.weatherDescription,
    required this.temperature,
    required this.windSpeed,
    required this.pressure,
    required this.chanceOfIce,
    required this.humidity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Location and Carousel Indicator
          Text(
            location,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.circle, size: 8, color: Colors.grey),
              SizedBox(width: 4),
              Icon(Icons.circle, size: 8, color: Colors.grey),
              SizedBox(width: 4),
              Icon(Icons.circle, size: 8, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 16),
          
          // Main Weather Information in Two Columns
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Weather Icon Column
              const Column(
                children: [
                  Icon(
                    Icons.cloud, // Use an appropriate weather icon
                    size: 64,
                    color: Colors.blueAccent,
                  ),
                ],
              ),
              // Date and Temperature Column
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    date,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$temperature°',
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    weatherDescription,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Weather Details in Grid Style (2x2)
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 3,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildWeatherDetail(Icons.air, windSpeed, 'Wind'),
              _buildWeatherDetail(Icons.compress, pressure, 'Pressure'),
              _buildWeatherDetail(Icons.ac_unit, chanceOfIce, 'Chance of Ice'),
              _buildWeatherDetail(Icons.water_drop, humidity, 'Humidity'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(IconData icon, String valueWithUnit, String label) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueAccent, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(valueWithUnit, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ],
    );
  }
}
