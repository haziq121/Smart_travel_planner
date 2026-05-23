import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {

  Future<Map<String, dynamic>?> getWeatherByCoords(
    double lat,
    double lon,
  ) async {

    String apiKey = "6721dfe444ea301a6f109b74d7e3dfab";

    String url =
        "https://api.openweathermap.org/data/2.5/weather"
        "?lat=$lat&lon=$lon&appid=$apiKey&units=metric";

    final response = await http.get(Uri.parse(url));

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getWeather(String city) async {

    String apiKey = "6721dfe444ea301a6f109b74d7e3dfab";

    String url =
        "https://api.openweathermap.org/data/2.5/weather"
        "?q=$city&appid=$apiKey&units=metric";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }
}