import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationPicker extends StatefulWidget {
  final Function(LatLng) onLocationSelected;

  const LocationPicker({super.key, required this.onLocationSelected});

  @override
  LocationPickerState createState() => LocationPickerState();
}

class LocationPickerState extends State<LocationPicker> {
  LatLng? _selectedLocation;
  late GoogleMapController _mapController;
  final Location _location = Location();

  @override
  void initState() {
    super.initState();
    _checkLocationService();
  }

  void _checkLocationService() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Check if location services are enabled
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      // Request the user to enable location services
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    // Check if location permissions are granted
    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Navigate to the user's current location
    navigateToUserLocation();
  }

  void navigateToUserLocation() async {
    final userLocation = await _location.getLocation();
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(userLocation.latitude!, userLocation.longitude!),
          zoom: 15.0,
        ),
      ),
    );
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
              target: LatLng(37.7749, -122.4194),
              zoom: 10,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (controller) {
              _mapController = controller;
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

          // Search Bar at the Top Center
          Positioned(
            top: screenHeight * 0.03,
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search location...',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.04,
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.01,
                  ),
                ),
                onSubmitted: (value) {
                  // Implement Google Places API to search for location
                },
              ),
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
                    _mapController.animateCamera(
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
                Gap(screenHeight * 0.01),
                OutlinedButton(
                  onPressed: () {
                    _mapController.animateCamera(
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
                Gap(screenHeight * 0.01),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: const CircleBorder(),
                    side: const BorderSide(color: Colors.grey, width: 1.5),
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    backgroundColor: Colors.transparent,
                  ),
                  onPressed: () {
                    navigateToUserLocation();
                  },
                  child: Icon(
                    Icons.my_location,
                    color: const Color.fromARGB(255, 18, 18, 18),
                    size: screenWidth * 0.06,
                  ),
                ),
              ],
            ),
          ),

          // Confirm Button
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
                    color: Colors.white,
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
