import 'dart:convert';
import 'package:http/http.dart' as http;

class CityService {

  Future<List<dynamic>> getCities(String name) async {

   String url =
"https://wft-geo-db.p.rapidapi.com/v1/geo/cities?countryIds=PK&namePrefix=$name&limit=10";

    final response = await http.get(
      Uri.parse(url),
      headers: {
"X-RapidAPI-Key": "22d7c9b727msha3fdda2dad77c47p11fa91jsn21145f550571",
        "X-RapidAPI-Host": "wft-geo-db.p.rapidapi.com",
      },
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      return [];
    }
  }
}