import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final List<Map<String, dynamic>> weatherData;

  const WeatherCard({
    super.key,
    required this.weatherData,
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
          SizedBox(
            height: 330, // Fixed height for the carousel
            child: PageView.builder(
              itemCount: weatherData.length,
              itemBuilder: (context, index) {
                final weather = weatherData[index];
                return Column(
                  children: [
                    // Location and Indicator
                    Text(
                      weather['location'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        weatherData.length,
                        (dotIndex) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Icon(
                            Icons.circle,
                            size: 8,
                            color: index == dotIndex
                                ? Colors.blueAccent
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Weather Information
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Icon(
                          Icons.cloud,
                          size: 64,
                          color: Colors.blueAccent,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              weather['date'],
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${weather['temperature']}°',
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              weather['weatherDescription'],
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Weather Details
                    Center(
                      child: SizedBox(
                        width: 300, // Adjust this width to control centering
                        child: GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 3,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _buildWeatherDetail(Icons.air, weather['windSpeed'], 'Wind'),
                            _buildWeatherDetail(Icons.compress, weather['pressure'], 'Pressure'),
                            _buildWeatherDetail(Icons.ac_unit, weather['chanceOfIce'], 'Chance of Ice'),
                            _buildWeatherDetail(Icons.water_drop, weather['humidity'], 'Humidity'),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(IconData icon, String valueWithUnit, String label) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.blueAccent, size: 20),
            const SizedBox(width: 8),
          ]
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(valueWithUnit,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ],
    );
  }
}
