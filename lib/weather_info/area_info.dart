import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

// Class to hold temperature information
class TemperatureInfo {
  final String value;
  final String hour;

  const TemperatureInfo({required this.value, required this.hour});

  @override
  String toString() => "$hour: $value";
}

// StatefulWidget to display area-specific weather information
class AreaInfo extends StatefulWidget {
  final XmlDocument weatherData;
  final String area;

  const AreaInfo({required this.weatherData, required this.area, super.key});

  @override
  State<AreaInfo> createState() => _AreaInfoState();
}

class _AreaInfoState extends State<AreaInfo> {
  late XmlDocument weatherData;
  late String area;

  @override
  void initState() {
    super.initState();
    weatherData = widget.weatherData;
    area = widget.area;
  }

  @override
  Widget build(BuildContext context) {
    // Extract the relevant temperature data for the specific area
    final temperatures = weatherData
        .xpath(
            'data/forecast/area[@description="$area"]/parameter[@description="Temperature"]/timerange')
        .toList();

    // Transform XML data into a list of TemperatureInfo objects
    final List<TemperatureInfo> temperatureInfo = temperatures.map((e) {
      final hour = e.getAttribute("datetime");
      return TemperatureInfo(
        value: e.xpath("value[@unit='C']").first.innerText,
        hour:
            "${hour?.substring(0, 4)}-${hour?.substring(4, 6)}-${hour?.substring(6, 8)} ${hour?.substring(8, 10)}:${hour?.substring(10, 12)}",
      );
    }).toList();

    log(temperatureInfo.join(', '));

    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: temperatureInfo.length,
        itemBuilder: (context, index) {
          // Parse temperature value and determine which icon to use
          final tempValue =
              double.tryParse(temperatureInfo[index].value) ?? 0.0;

          final IconData tempIcon;
          if (tempValue > 30) {
            tempIcon = Icons.wb_sunny; // High temperature
          } else if (tempValue > 20) {
            tempIcon = Icons.wb_cloudy; // Moderate temperature
          } else {
            tempIcon = Icons.ac_unit; // Low temperature
          }

          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: ListTile(
              leading: Text(temperatureInfo[index].hour),
              title: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(tempIcon, color: Colors.blue),
                    const SizedBox(width: 8.0),
                    Text("${temperatureInfo[index].value}°C",
                        style: const TextStyle(fontSize: 20.0)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
