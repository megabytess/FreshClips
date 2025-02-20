import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/client-features/controllers/client_controller.dart';
import 'package:gap/gap.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClientNearbyPage extends StatefulWidget {
  const ClientNearbyPage({super.key});

  @override
  State<ClientNearbyPage> createState() => _ClientNearbyPageState();
}

class _ClientNearbyPageState extends State<ClientNearbyPage> {
  final TextEditingController _searchController = TextEditingController();
  late GoogleMapController mapController;
  ClientController clientController = ClientController();
  Position? currentPosition;
  LatLng? selectedLocation;

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
        selectedLocation = LatLng(position.latitude, position.longitude);
      });

      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: selectedLocation!,
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
    if (currentPosition != null) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target:
                LatLng(currentPosition!.latitude, currentPosition!.longitude),
            zoom: 16.0,
          ),
        ),
      );
    }
  }

  Future<void> searchLocation(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        LatLng searchedLocation = LatLng(location.latitude, location.longitude);
        mapController.animateCamera(
          CameraUpdate.newLatLng(searchedLocation),
        );

        double distance = Geolocator.distanceBetween(
          currentPosition!.latitude,
          currentPosition!.longitude,
          searchedLocation.latitude,
          searchedLocation.longitude,
        );
        print('Distance: $distance meters');
      }
    } catch (e) {
      print('Error occurred while searching location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: onMapCreated,
            initialCameraPosition: const CameraPosition(
              target: LatLng(10.3157, 123.8854),
              zoom: 11.0,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),
          Positioned(
            bottom: 20,
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
            child: Column(
              children: [
                Container(
                  width: screenWidth * 3,
                  height: screenHeight * 0.07,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: screenWidth * 0.8,
                        child: TextField(
                          controller: _searchController,
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.04,
                            color: const Color.fromARGB(255, 18, 18, 18),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search nearby',
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: screenWidth * 0.037,
                            ),
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: const Color.fromARGB(255, 18, 18, 18),
                              size: screenWidth * 0.06,
                            ),
                          ),
                          onSubmitted: (value) {
                            searchLocation(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 20,
            right: 10,
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
                    color: const Color.fromARGB(255, 18, 18, 18),
                    size: screenWidth * 0.06,
                  ),
                ),
                Gap(screenHeight * 0.001),
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
                    color: const Color.fromARGB(255, 18, 18, 18),
                    size: screenWidth * 0.06,
                  ),
                ),
                Gap(screenHeight * 0.001),
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
                    color: const Color.fromARGB(255, 18, 18, 18),
                    size: screenWidth * 0.06,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
