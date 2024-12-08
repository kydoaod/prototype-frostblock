import 'package:flutter/material.dart';
import 'package:frostblok/widgets/weather_widgets.dart';
import 'package:frostblok/widgets/device_widget.dart';
import 'package:frostblok/pages/defrost_device.dart';  // Import DefrostDevicePage
import 'package:frostblok/api/weather_api.dart';  // Import the WeatherApi class

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  final Key refreshKey = const Key('refresh-homepage'); // Unique key for state refresh

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin  {
  List<Map<String, dynamic>> weatherData = [];


  @override
  bool get wantKeepAlive => true; // Keep the widget state alive

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload weather data when this page is returned to (useful when switching tabs)
    if (weatherData.isEmpty) {
      _loadWeatherData();
    }
  }

  List<Widget> deviceCards = [
    DeviceCard(
      temperature: 29,
      location: 'Garden City, UT',
      status: 'Drains are Safe!',
      onToggle: () {},
      onTap: (context) {
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DefrostDevicePage()),
            );
          },
        ),
      );
    });
  }

  Future<void> _loadWeatherData() async {
    try {
      // Fetch geocode data (lat, lon) for San Pedro, Laguna
      //final sanPedroData = await WeatherApi.getGeocodeData('San Pedro, Laguna');
      //final sanPedroLat = sanPedroData['lat'];
      //final sanPedroLon = sanPedroData['lon'];

      // Fetch weather forecast for San Pedro
      //final sanPedroWeather = await WeatherApi.getWeatherForecast(sanPedroLat, sanPedroLon);

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
        for(var forecast in forecasts){
          weatherData.add({
            'location': location,
            'date': 'Today | ${_formatDate(forecast['dt'])}',
            'weatherClassification': forecast['weather'][0]['main'] ?? 'No description',
            'weatherDescription': forecast['weather'][0]['description'] ?? 'No description',
            'temperature': _kelvinToCelsius(forecast['main']['temp']).toStringAsFixed(2),
            'windSpeed': '${forecast['wind']['speed']} m/s',
            'pressure': '${forecast['main']['pressure']} hPa',
            'chanceOfIce': 'N/A', // Example value, adjust based on the data
            'humidity': '${forecast['main']['humidity']}%',
          });
        }
      });
    } 
  }
  
  void refresh() {
    _loadWeatherData();
  }

  double _kelvinToCelsius(double kelvin) {
    return kelvin - 273.15;  // Conversion formula
  }

  String _formatDate(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${date.month}/${date.day}/${date.year}'; // Customize this format as needed
  }

  @override
  void initState() {
    super.initState();
    _loadWeatherData();  // Load weather data on page initialization
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);  // Ensure AutomaticKeepAliveClientMixin works
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
                ...deviceCards,  // Keep device cards as is
              ],
            ),
          ),
        ),
      ),
    );
  }

}
