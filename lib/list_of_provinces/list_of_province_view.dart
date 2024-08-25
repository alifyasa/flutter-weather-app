import 'package:flutter/material.dart';
import 'package:weather/list_of_provinces/list_of_provinces_data.dart';

class ListOfProvinceScreen extends StatelessWidget {

  const ListOfProvinceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item List'),
      ),
      body: ListView.builder(
        itemCount: provinces.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(provinces[index].name),
            onTap: () {
              Navigator.pop(context, provinces[index]);
            },
          );
        },
      ),
    );
  }
}
