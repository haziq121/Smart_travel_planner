import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';

import 'package:latlong2/latlong.dart';

class MapScreen extends StatelessWidget {

  final double latitude;
  final double longitude;
  final String city;

  const MapScreen({

    super.key,

    required this.latitude,
    required this.longitude,
    required this.city,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text(city),
      ),

      body: FlutterMap(

        options: MapOptions(

          initialCenter:
          LatLng(latitude, longitude),

          initialZoom: 10,
        ),

        children: [

          TileLayer(

            urlTemplate:

"https://tile.openstreetmap.org/{z}/{x}/{y}.png",

            userAgentPackageName:
            "com.example.smart_travel_planner",
          ),

          MarkerLayer(

            markers: [

              Marker(

                point:
                LatLng(latitude, longitude),

                width: 80,
                height: 80,

                child: const Icon(

                  Icons.location_pin,

                  color: Colors.red,

                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}