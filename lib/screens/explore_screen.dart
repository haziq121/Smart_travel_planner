import 'package:flutter/material.dart';
import '../services/places_service.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() =>
      _ExploreScreenState();
}

class _ExploreScreenState
    extends State<ExploreScreen> {

  final TextEditingController
  cityController =
  TextEditingController();

  List places = [];

  bool isLoading = false;

  void searchPlaces() async {

    setState(() {
      isLoading = true;
    });

    places = await PlacesService()
        .searchPlaces(
      cityController.text.trim(),
    );

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Explore Places"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(15),

        child: Column(

          children: [

            Row(

              children: [

                Expanded(

                  child: TextField(

                    controller:
                    cityController,

                    decoration:
                    InputDecoration(

                      hintText:
                      "Search City",

                      border:
                      OutlineInputBorder(

                        borderRadius:
                        BorderRadius.circular(
                            12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                ElevatedButton(

                  onPressed:
                  searchPlaces,

                  child:
                  const Text("Search"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            if(isLoading)
              const CircularProgressIndicator(),

            Expanded(

              child: ListView.builder(

                itemCount: places.length,

                itemBuilder:
                    (context, index) {

                  var place =
                  places[index];

                  return Card(

                    child: ListTile(

                      leading:
                      const Icon(
                        Icons.place,
                      ),

                      title: Text(
                        place['name'] ??
                            "Unknown",
                      ),

                      subtitle: Text(

                        place['location']
                        ['formatted_address']
                            ??
                            "",
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}