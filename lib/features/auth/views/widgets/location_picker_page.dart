import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/auth/models/autocomplete_predictions.dart';
import 'package:gap/gap.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

class LocationPicker extends StatefulWidget {
  final Function(LatLng) onLocationSelected;

  const LocationPicker({super.key, required this.onLocationSelected});

  @override
  LocationPickerState createState() => LocationPickerState();
}

class LocationPickerState extends State<LocationPicker> {
  LatLng? _selectedLocation;
  late GoogleMapController mapController;
  final loc.Location location = loc.Location();
  List<AutocompletePrediction> placePredictions = [];
  Position? currentPosition;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkAndRequestLocationPermission();
  }

  Future<void> checkAndRequestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Location permissions are permanently denied. Please enable them in settings.',
          ),
        ),
      );
      return;
    }

    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _selectedLocation = LatLng(position.latitude, position.longitude);
      });

      // Ensure controller is initialized
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _selectedLocation!,
            zoom: 16.0,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get location: $e')),
      );
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> searchLocation(String query) async {
    if (query.isEmpty) return;

    try {
      print('Searching for: $query');
      List<Location> locations = await locationFromAddress(query);
      print('Found locations: $locations');

      if (locations.isNotEmpty) {
        Location location = locations.first;
        LatLng searchedLocation = LatLng(location.latitude, location.longitude);

        print(
            'Moving camera to: ${searchedLocation.latitude}, ${searchedLocation.longitude}');

        // Ensure mapController is initialized before using it
        mapController.animateCamera(
          CameraUpdate.newLatLng(searchedLocation),
        );

        setState(() {
          _selectedLocation = searchedLocation;
        });
      } else {
        print('No locations found for: $query');
      }
    } catch (e) {
      print('Error while searching: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Pick Location',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 45, 65, 69),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(10.3157, 123.8854),
              zoom: 10,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (controller) {
              mapController = controller;
            },
            onTap: (LatLng location) {
              setState(() {
                _selectedLocation = location;
              });
            },
            markers: _selectedLocation != null
                ? {
                    Marker(
                      markerId: const MarkerId('selected-location'),
                      position: _selectedLocation!,
                    )
                  }
                : {},
          ),

          // Search Bar and Autocomplete List
          Positioned(
            top: screenHeight * 0.02,
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 248, 248, 248),
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(255, 45, 65, 69),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: screenHeight * 0.06,
                    child: TextField(
                      controller: searchController,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                        color: const Color.fromARGB(255, 45, 65, 69),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search location',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.035,
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                          vertical: screenHeight * 0.015,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.search_rounded,
                            color: const Color.fromARGB(255, 45, 65, 69),
                            size: screenWidth * 0.06,
                          ),
                          onPressed: () {
                            searchLocation(searchController.text);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Zoom and Current Location Buttons
          Positioned(
            top: screenHeight * 0.1,
            right: screenWidth * 0.01,
            child: Column(
              children: [
                OutlinedButton(
                  onPressed: () {
                    mapController.animateCamera(
                      CameraUpdate.zoomIn(),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    shape: const CircleBorder(),
                    side: const BorderSide(color: Colors.grey, width: 1.5),
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    backgroundColor: Colors.transparent,
                  ),
                  child: Icon(
                    Icons.add,
                    color: const Color.fromARGB(255, 45, 65, 69),
                    size: screenWidth * 0.06,
                  ),
                ),
                Gap(screenHeight * 0.01),
                OutlinedButton(
                  onPressed: () {
                    mapController.animateCamera(
                      CameraUpdate.zoomOut(),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    shape: const CircleBorder(),
                    side: const BorderSide(color: Colors.grey, width: 1.5),
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    backgroundColor: Colors.transparent,
                  ),
                  child: Icon(
                    Icons.remove,
                    color: const Color.fromARGB(255, 45, 65, 69),
                    size: screenWidth * 0.06,
                  ),
                ),
                Gap(screenHeight * 0.01),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: const CircleBorder(),
                    side: const BorderSide(color: Colors.grey, width: 1.5),
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    backgroundColor: Colors.transparent,
                  ),
                  onPressed: () {
                    getCurrentLocation();
                  },
                  child: Icon(
                    Icons.my_location,
                    color: const Color.fromARGB(255, 45, 65, 69),
                    size: screenWidth * 0.06,
                  ),
                ),
              ],
            ),
          ),

          // Confirm Location Button
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: SizedBox(
              width: double.infinity,
              height: screenHeight * 0.06,
              child: FloatingActionButton(
                onPressed: () {
                  if (_selectedLocation != null) {
                    widget.onLocationSelected(_selectedLocation!);
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select a location')),
                    );
                  }
                },
                backgroundColor: const Color.fromARGB(255, 45, 65, 69),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    screenWidth * 0.05,
                  ),
                ),
                child: Text(
                  'Confirm location',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.035,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(255, 248, 248, 248),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
