import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class ClientNearbyPage extends StatefulWidget {
  const ClientNearbyPage({super.key});

  @override
  State<ClientNearbyPage> createState() => _ClientNearbyPageState();
}

class _ClientNearbyPageState extends State<ClientNearbyPage> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(45.521563, -122.677433);
  final Location _location = Location();
  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _addMarkers();
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

  void _addMarkers() {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('marker_1'),
          position: LatLng(45.521563, -122.677433),
          infoWindow: InfoWindow(
            title: 'Marker 1',
            snippet: 'This is a marker',
          ),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId('marker_2'),
          position: LatLng(45.531563, -122.687433),
          infoWindow: InfoWindow(
            title: 'Marker 2',
            snippet: 'This is another marker',
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            markers: _markers,
          ),
          Positioned(
            top: 20,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: const Color.fromARGB(255, 248, 248, 248),
              onPressed: _navigateToUserLocation,
              child: Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
