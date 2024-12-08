import 'package:flutter/material.dart';
import 'package:frostblok/utils/converters.dart';
import 'package:frostblok/widgets/weather_widgets.dart';
import 'package:frostblok/widgets/device_card_widget.dart';  // Import DeviceCard
import 'package:frostblok/pages/defrost_device.dart';  // Import DefrostDevicePage
import 'package:frostblok/api/weather_api.dart';  // Import the WeatherApi class
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  final Key refreshKey = const Key('refresh-homepage'); // Unique key for state refresh

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin  {
  List<Map<String, dynamic>> weatherData = [];
  List<Map<String, dynamic>> devices = [
    {
      'temperature': 29,
      'location': 'Garden City, UT',
      'status': 'off',
    },
  ];

  @override
  bool get wantKeepAlive => true; // Keep the widget state alive

  void _toggleDeviceStatus(int index) {
    setState(() {
      devices[index]['status'] = devices[index]['status'] == 'on' ? 'off' : 'on';
    });
  }

  void _navigateToDefrostDevicePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DefrostDevicePage()),
    );
  }

  void _addNewDevice() {
    setState(() {
      devices.add({
        'temperature': 30,
        'location': 'New Location ${devices.length + 1}',
        'status': 'off',
      });
    });
  }

  Future<void> _loadWeatherData() async {
    try {
      // Fetch geocode data (lat, lon) for Muntinlupa
      final muntinlupaData = await WeatherApi.getGeocodeData('Muntinlupa');
      final muntinlupaLat = muntinlupaData['lat'];
      final muntinlupaLon = muntinlupaData['lon'];

      // Fetch weather forecast for Muntinlupa
      final muntinlupaWeather = await WeatherApi.getWeatherForecast(muntinlupaLat, muntinlupaLon);

      // Check if the weather data is available
      _formatWeatherData('Muntinlupa', muntinlupaWeather);
    } catch (e) {
      // Handle error loading weather data
      print('Error fetching weather data: $e');
    }
  }

  void _formatWeatherData(String location, Map<String, dynamic> weather) {
    // Ensure the forecast exists and is not empty
    final forecasts = weather['forecast'];
    if (forecasts != null && forecasts.isNotEmpty) {
      setState(() {
        for (var forecast in forecasts) {
          double tempCelsius = kelvinToCelsius(forecast['main']['temp']);
          double humidity = forecast['main']['humidity'].toDouble();
          double rain = forecast['rain']?['3h'] ?? 0.0; // Rain in the past 3 hours, if available

          String chanceOfIce = calculateChanceOfIce(tempCelsius, humidity, rain);

          // Formatting the date and time
          var dateTime = DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000);
          String dayOfWeek = DateFormat('EEEE').format(dateTime); // Gets day of the week
          String formattedDate = DateFormat('MMMdd').format(dateTime); // Gets the date in "Nov14" format
          String timeOfDay = DateFormat('h:mm a').format(dateTime); // Time in "3:30 PM" format

          weatherData.add({
            'location': location,
            'date': '$dayOfWeek | $formattedDate $timeOfDay',
            'weatherClassification': forecast['weather'][0]['main'] ?? 'No description',
            'weatherDescription': forecast['weather'][0]['description'] ?? 'No description',
            'temperature': tempCelsius.toStringAsFixed(2),
            'windSpeed': '${forecast['wind']['speed']} m/s',
            'pressure': '${forecast['main']['pressure']} hPa',
            'chanceOfIce': chanceOfIce,
            'humidity': '${forecast['main']['humidity']}%',
          });
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload weather data when this page is returned to (useful when switching tabs)
    if (weatherData.isEmpty) {
      _loadWeatherData();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                WeatherCard(weatherData: weatherData),  // Pass the weather data to WeatherCard
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
                    padding: EdgeInsets.symmetric(vertical: 16.0),
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
                ...devices.asMap().entries.map((entry) {
                  int index = entry.key;
                  var device = entry.value;
                  return DeviceCard(
                    temperature: device['temperature'],
                    location: device['location'],
                    status: device['status'],
                    onToggle: () => _toggleDeviceStatus(index),
                    onTap: (context) => _navigateToDefrostDevicePage(context),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
