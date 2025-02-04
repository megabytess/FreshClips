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
  LatLng? currentLocation;
  ClientController clientController = ClientController();

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, don't continue
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, don't continue
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, don't continue
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can continue
    Position position = await Geolocator.getCurrentPosition();
    currentLocation = LatLng(position.latitude, position.longitude);
    mapController.animateCamera(
      CameraUpdate.newLatLng(currentLocation!),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _searchLocation(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        LatLng searchedLocation = LatLng(location.latitude, location.longitude);
        mapController.animateCamera(
          CameraUpdate.newLatLng(searchedLocation),
        );

        if (currentLocation != null) {
          double distance = Geolocator.distanceBetween(
            currentLocation!.latitude,
            currentLocation!.longitude,
            searchedLocation.latitude,
            searchedLocation.longitude,
          );
          print('Distance: $distance meters');
        }
      }
      //  const clientController.clientLocation.location[0].latitude = locations[0].latitude;
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
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(
              target: LatLng(45.521563, -122.677433), // Default center
              zoom: 11.0,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: true, // Disable default zoom controls
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
                            _searchLocation(value);
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
                  onPressed: () {},
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
                  onPressed: () {},
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
                  onPressed: _determinePosition,
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
