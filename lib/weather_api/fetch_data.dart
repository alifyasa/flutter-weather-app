import 'package:weather/list_of_provinces/list_of_provinces_data.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

Future<XmlDocument> fetchWeatherData(Province province) async {
  String url =
      'https://data.bmkg.go.id/DataMKG/MEWS/DigitalForecast/${province.code}';

  final response = await http.get(Uri.parse(url));
  
  if (response.statusCode == 200) {
    return XmlDocument.parse(response.body);
  } else {
    throw Exception('Failed to load data');
  }
}
