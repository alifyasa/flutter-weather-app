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

    // Set the selectedArea to the first city available in XML data
    selectedArea = weatherData
        .xpath('data/forecast/area/name[@xml:lang="en_US"]')
        .map((e) => e.innerText)
        .first;
  }

  @override
  Widget build(BuildContext context) {
    // Extract timestamp details from the XML data for display purposes
    final timestampYear =
        weatherData.xpath('data/forecast/issue/year').first.innerText;
    final timestampMonth =
        weatherData.xpath('data/forecast/issue/month').first.innerText;
    final timestampDay =
        weatherData.xpath('data/forecast/issue/day').first.innerText;

    // Retrieve the list of cities from the XML data for the dropdown menu
    List<String> cities = weatherData
        .xpath('data/forecast/area/name[@xml:lang="en_US"]')
        .map((e) => e.innerText)
        .toList();

    log("Areas: ${selectedArea ?? 'None'} - ${cities.join(', ')}");

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Weather Info for: $selectedArea", 
        ),
        Text(
          "Last Updated: $timestampYear-$timestampMonth-$timestampDay",
        ),
        const SizedBox(height: 8.0),
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
        const SizedBox(height: 8.0),
        selectedArea != null
            ? AreaInfo(
                key: ValueKey(selectedArea!),
                weatherData: weatherData,
                area: selectedArea!
              )
            : const CircularProgressIndicator(),
      ],
    );
  }
}
