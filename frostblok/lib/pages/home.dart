import 'package:flutter/material.dart';
import 'package:frostblok/pages/add_device.dart';
import 'package:frostblok/widgets/weather_widgets.dart';
import 'package:frostblok/widgets/device_card_widget.dart';  // Import DeviceCard
import 'package:frostblok/pages/defrost_device.dart';  // Import DefrostDevicePage
import 'package:frostblok/api/weather_api.dart';
import 'package:tuya_flutter/tuya_flutter.dart';  // Import the WeatherApi class

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
    int ledToggle = devices[index]['status'] == 'on' ? 0 : 1;
    print("-----${devices[index]}");
    TuyaFlutter.sendDpCommand(devId: devices[index]['devId'], dpId: '101', dpValue: ledToggle); 
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

  void _addNewDevice() async {
    // setState(() {
    //   devices.add({
    //     'temperature': 30,
    //     'location': 'New Location ${devices.length + 1}',
    //     'status': 'off',
    //   });
    // });


    final newDevice = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddDevicePage()),
    );

    // Check if newDevice contains location data and add a new device
    print("newDevice $newDevice");
    if (newDevice != null && newDevice['location'] != null && newDevice['ezDevice'] != null) {
      setState(() {
        devices.add({
          'temperature': 30, // Default temperature, you can modify later
          'location': newDevice['location'],
          'status': 'off',
          'devId': newDevice['ezDevice']['devId']
        });
        print(newDevice['ezDevice']['devId']);
      });
    }
  }


  Future<void> _loadWeatherData() async {
    try {
      final weather = await WeatherApi.getWeatherForecast('Muntinlupa', 3);
      _formatWeatherData('Muntinlupa', weather);
    } catch (e, stackTrace) {
    print('Error fetching weather data: $e');
    print('Stack trace: $stackTrace'); // Ito ang magpapakita ng buong stack trace
  }
  }

  void _formatWeatherData(String location, Map<String, dynamic> weather) {
    final forecasts = weather['forecast'];
    if (forecasts != null && forecasts.isNotEmpty) {
      weatherData.clear();
      setState(() {
        for (var forecast in forecasts) {
          print(forecast['hour'][0]['pressure_mb']); //avghumidity
          weatherData.add({
            'location': weather['location'],
            'date': forecast['date'],
            'temperature': forecast['day']['avgtemp_c'].round(),
            'condition': forecast['day']['condition']['text'],
            'icon': forecast['day']['condition']['icon'],
            'weatherClassification': forecast['day']['condition']['text'].split(' ').last,
            'weatherDescription': forecast['day']['condition']['text'],
            'windSpeed': forecast['day']['avgvis_miles'].toString(),
            'pressure': forecast['hour'][0]['pressure_mb'].toString(),
            'humidity': forecast['day']['avghumidity'].toString(),
            'chanceOfIce': '${forecast['day']['daily_chance_of_snow']}%',
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
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
