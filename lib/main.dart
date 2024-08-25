import 'package:flutter/material.dart';
import 'package:weather/list_of_provinces/list_of_province_view.dart';
import 'package:weather/list_of_provinces/list_of_provinces_data.dart';

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
  Province selectedProvince = Province('Provinsi DKI Jakarta', 'DigitalForecast-DKIJakarta.xml');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ListOfProvinceScreen()),
                );
                if (result != null) {
                  setState(() {
                    selectedProvince = result;
                  });
                }
              },
              child: Text(selectedProvince.name),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemListScreen extends StatelessWidget {
  final List<String> items = List<String>.generate(20, (index) => 'Item ${index + 1}');

  ItemListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item List'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index]),
            onTap: () {
              Navigator.pop(context, items[index]);
            },
          );
        },
      ),
    );
  }
}
