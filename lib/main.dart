import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:weather/list_of_provinces/list_of_province_view.dart';
import 'package:weather/list_of_provinces/list_of_provinces_data.dart';
import 'package:weather/weather_api/fetch_data.dart';
import 'package:weather/weather_info/weather_info.dart';
import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  Province? _selectedProvince;
  XmlDocument? _weatherXmlDocument;

  @override
  void initState() {
    super.initState();
    // Default province selected, this can be later changed via the UI
    _selectedProvince =
        Province('Provinsi DKI Jakarta', 'DigitalForecast-DKIJakarta.xml');
    _loadWeatherData();
  }

  // Loads weather data for the selected province
  Future<void> _loadWeatherData() async {
    if (_selectedProvince != null) {
      final weatherData =
          await fetchWeatherData(_selectedProvince!) as XmlDocument?;
      if (weatherData != null) {
        log(weatherData.xpath('data/forecast/issue/timestamp').first.innerText);
      }
      setState(() {
        _weatherXmlDocument = weatherData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedProvince?.name ?? 'Loading...',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              // Navigate to the list of provinces, and wait for a result
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ListOfProvinceScreen(),
                ),
              );
              // Update the selected province and reload data if a new province is selected
              if (result != null && result is Province) {
                setState(() {
                  _selectedProvince = result;
                  _weatherXmlDocument = null; // Clear current data
                });
                _loadWeatherData(); // Reload data for new province
              }
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: _weatherXmlDocument == null
            ? const Expanded(
                child: Center(
                    child:
                        CircularProgressIndicator())) // Show spinner while loading
            : WeatherInfo(
                weatherData:
                    _weatherXmlDocument!), // Show weather info if data is loaded
      ),
    );
  }
}
