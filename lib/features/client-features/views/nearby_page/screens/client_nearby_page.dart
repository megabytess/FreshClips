import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class ClientNearbyPage extends StatefulWidget {
  const ClientNearbyPage({super.key});

  @override
  State<ClientNearbyPage> createState() => _ClientNearbyPageState();
}

class _ClientNearbyPageState extends State<ClientNearbyPage> {
  late GoogleMapController mapController;
  final Location _location = Location();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeUserLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _initializeUserLocation();
  }

  Future<void> _initializeUserLocation() async {
    final userLocation = await _location.getLocation();
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(userLocation.latitude!, userLocation.longitude!),
          zoom: 15.0,
        ),
      ),
    );
  }

  void _navigateToUserLocation() async {
    final userLocation = await _location.getLocation();
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(userLocation.latitude!, userLocation.longitude!),
          zoom: 15.0,
        ),
      ),
    );
  }

  void _zoomIn() {
    mapController.animateCamera(CameraUpdate.zoomIn());
  }

  void _zoomOut() {
    mapController.animateCamera(CameraUpdate.zoomOut());
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
            zoomControlsEnabled: false, // Disable default zoom controls
          ),
          Positioned(
            bottom: 20,
            left: screenWidth * 0.1,
            right: screenWidth * 0.1,
            child: Column(
              children: [
                Container(
                  width: screenHeight * 2,
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
                        width: screenWidth * 0.61,
                        child: TextField(
                          controller: _searchController,
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.04,
                            color: const Color.fromARGB(255, 18, 18, 18),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search nearby barbers',
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: screenWidth * 0.035,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      // Optional search button or icon
                      IconButton(
                        icon: Icon(
                          Icons.location_searching_rounded,
                          color: const Color.fromARGB(255, 18, 18, 18),
                          size: screenWidth * 0.06,
                        ),
                        onPressed: () {
                          // Define the search action here
                          print('Searching for: ${_searchController.text}');
                        },
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
                  onPressed: _zoomIn,
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
                  onPressed: _zoomOut,
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
                  onPressed: _navigateToUserLocation,
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
