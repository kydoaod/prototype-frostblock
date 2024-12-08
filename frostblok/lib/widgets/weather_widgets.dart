import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frostblok/utils/svg_icons.dart';

class WeatherCard extends StatelessWidget {
  final List<Map<String, dynamic>> weatherData;

  const WeatherCard({
    super.key,
    required this.weatherData,
  });

  SvgPicture _getWeatherIcon(String weatherClassification,
    {double size = 64, Color? color}) {
    switch (weatherClassification.toLowerCase()) {
      case 'clear':
        return SvgIcons.cloudSunny(size: size, color: color);
      case 'rain':
      case 'shower rain':
      case 'light rain':
        return SvgIcons.cloudSunshower(size: size, color: color);
      case 'snow':
        return SvgIcons.cloudSnow(size: size, color: color);
      case 'clouds':
        return SvgIcons.cloudClouds(size: size, color: color);
      case 'thunderstorm':
        return SvgIcons.cloudThunderstorm(size: size, color: color);
      case 'drizzle':
        return SvgIcons.cloudDrizzle(size: size, color: color);
      case 'mist':
      case 'fog':
        return SvgIcons.cloudMistFog(size: size, color: color);
      default:
        return SvgIcons.cloudHelpOutline(size: size, color: color);
    }
  }



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
            height: 310, // Fixed height for the carousel
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
                        _getWeatherIcon(weather['weatherClassification'] ?? ''),
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
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 8),
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
                            _buildWeatherDetail(SvgIcons.indicatorWindDir(size: 20, color: Colors.black), weather['windSpeed'], 'Wind'),
                            _buildWeatherDetail(SvgIcons.indicatorSnow(size: 20, color: Colors.black), weather['chanceOfIce'], 'Chance of Ice'),
                            _buildWeatherDetail(SvgIcons.indicatorTemperature(size: 20, color: Colors.black), weather['pressure'], 'Pressure'),
                            _buildWeatherDetail(SvgIcons.indicatorHumidity(size: 20, color: Colors.black), weather['humidity'], 'Humidity'),
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

  Widget _buildWeatherDetail(
      SvgPicture svgIcon, String valueWithUnit, String label) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            svgIcon,
            const SizedBox(width: 8),
          ],
        ),
        const SizedBox(width: 4),
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
