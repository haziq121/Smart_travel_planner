import 'package:flutter/material.dart';
import '../services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  const WeatherScreen({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Map<String, dynamic>? weatherData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadWeather();
  }

  void loadWeather() async {
    weatherData = await WeatherService().getWeatherByCoords(
      widget.latitude,
      widget.longitude,
    );

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather"),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())

          : weatherData == null
              ? const Center(
                  child: Text(
                    "Weather Not Available",
                    style: TextStyle(fontSize: 18),
                  ),
                )

              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text(
                        "${weatherData!['main']['temp']}°C",
                        style: const TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        weatherData!['weather'][0]['main'],
                        style: const TextStyle(
                          fontSize: 25,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        "Humidity: ${weatherData!['main']['humidity']}%",
                      ),
                    ],
                  ),
                ),
    );
  }
}