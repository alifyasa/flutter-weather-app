import 'package:flutter/material.dart';
import 'package:weather/list_of_provinces/list_of_provinces_data.dart';

// Display a screen where users can select a province from the list
class ListOfProvinceScreen extends StatelessWidget {
  const ListOfProvinceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Location',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        itemCount: provinces.length, // Number of provinces
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(provinces[index].name), // Display province name
            onTap: () {
              // Return the selected province when tapped
              Navigator.pop(context, provinces[index]);
            },
          );
        },
      ),
    );
  }
}
