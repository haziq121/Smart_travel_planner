import 'dart:convert';
import 'package:http/http.dart' as http;

class PlacesService {

  Future<List<dynamic>> searchPlaces(
      String city) async {

    String apiKey = "OQS1PGLMIODB3V0JKPDODDFONVVXPYBCRMEBIR5HZIIQ1GWM";

    String url =
        "https://api.foursquare.com/v3/places/search?near=$city&limit=10";

    final response = await http.get(

      Uri.parse(url),

      headers: {
        "Authorization": apiKey,
      },
    );

    if(response.statusCode == 200) {

      final data =
      jsonDecode(response.body);

      return data['results'];

    } else {

      return [];
    }
  }
}