import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:weather/weather_info/area_info.dart';
import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

class WeatherInfo extends StatefulWidget {
  final XmlDocument weatherData;

  const WeatherInfo({required this.weatherData, super.key});

  @override
  State<WeatherInfo> createState() => _WeatherInfoState();
}

class _WeatherInfoState extends State<WeatherInfo> {
  late XmlDocument weatherData;
  String? selectedArea;

  @override
  void initState() {
    super.initState();
    weatherData = widget.weatherData;

    // Initialize selectedArea to the first city available in the XML data
    selectedArea = weatherData
        .xpath('data/forecast/area/name[@xml:lang="en_US"]')
        .map((e) => e.innerText)
        .first;
  }

  @override
  Widget build(BuildContext context) {
    // Extract timestamp details from the XML data to display last update time
    final timestampYear =
        weatherData.xpath('data/forecast/issue/year').first.innerText;
    final timestampMonth =
        weatherData.xpath('data/forecast/issue/month').first.innerText;
    final timestampDay =
        weatherData.xpath('data/forecast/issue/day').first.innerText;

    // Retrieve the list of cities from the XML data to populate the dropdown menu
    List<String> cities = weatherData
        .xpath('data/forecast/area/name[@xml:lang="en_US"]')
        .map((e) => e.innerText)
        .toList();

    log("Areas: ${selectedArea ?? 'None'} - ${cities.join(', ')}");

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SizedBox(
            width: double.infinity,
            child: DropdownButton<String>(
              isExpanded: true,
              items: cities.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              value: selectedArea,
              hint: const Text('Select a City'),
              onChanged: (String? value) {
                setState(() {
                  selectedArea = value;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 4.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            "Weather Info for: $selectedArea",
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            "Last Updated: $timestampYear-$timestampMonth-$timestampDay",
          ),
        ),
        const SizedBox(height: 8.0),
        // Display weather information for the selected area
        selectedArea != null
            ? AreaInfo(
                key: ValueKey(selectedArea!),
                weatherData: weatherData,
                area: selectedArea!)
            : const CircularProgressIndicator(),
      ],
    );
  }
}
