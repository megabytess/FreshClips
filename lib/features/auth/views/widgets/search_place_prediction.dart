import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/auth/models/autocomplete_predictions.dart';
import 'package:freshclips_capstone/features/auth/models/location_list_tile.dart';
import 'package:freshclips_capstone/features/auth/models/place_auto_complete_response.dart';
import 'package:freshclips_capstone/features/auth/views/widgets/nerwork_utility.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const String apikey =
    'AIzaSyDdXaMN5htLGHo8BkCfefPpuTauwHGXItU'; // change this API

class SearchPlacePredictionPage extends StatefulWidget {
  const SearchPlacePredictionPage({super.key});

  @override
  State<SearchPlacePredictionPage> createState() =>
      _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchPlacePredictionPage> {
  List<AutocompletePrediction> placePredictions = [];
  void placeAutocomplete(String query) async {
    Uri uri = Uri.https(
      "maps.googleapis.com",
      'maps/api/place/autocomplete/json',
      {
        'input': query,
        'key': apikey,
      },
    );
    String? response = await NetworkUtility.fetchUrl(uri);
    if (response != null) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parseAutocompleteResult(response);
      if (result.predictions != null) {
        setState(
          () {
            placePredictions = result.predictions!;
          },
        );
        print(response);
      }
    }
  }

  Future<LatLng> fetchPlaceDetails(String placeId) async {
    Uri uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/details/json',
      {
        'place_id': placeId,
        'key': apikey,
      },
    );
    String? response = await NetworkUtility.fetchUrl(uri);
    if (response != null) {
      final json = jsonDecode(response);
      final location = json['result']['geometry']['location'];
      return LatLng(location['lat'], location['lng']);
    }
    throw Exception('Failed to fetch place details');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Form(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                onChanged: (value) {},
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: "Search your location",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Icon(
                      Icons.location_pin,
                      color: Color.fromARGB(255, 18, 18, 18),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Divider(
            height: 4,
            thickness: 4,
            color: Color.fromARGB(255, 248, 248, 248),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton.icon(
              onPressed: () {
                placeAutocomplete('Dubai');
              },
              icon: const Icon(
                Icons.location_pin,
                color: Color.fromARGB(255, 248, 248, 248),
              ),
              label: const Text("Use my Current Location"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 48, 65, 69),
                foregroundColor: Color.fromARGB(255, 248, 248, 248),
                elevation: 0,
                fixedSize: const Size(double.infinity, 40),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),
          const Divider(
            height: 4,
            thickness: 4,
            color: Colors.grey,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: placePredictions.length,
              itemBuilder: (context, index) => LocationListTile(
                press: () {},
                location: placePredictions[index].description!,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
