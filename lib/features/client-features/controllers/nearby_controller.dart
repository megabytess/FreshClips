import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class NearbyController extends ChangeNotifier {
  Position? currentPosition;
  Set<Marker> markers = {};
  List<Map<String, dynamic>> nearbyUsers = [];

  // Fetches the user's profile image from the database.
  Future<String> getUserProfileImage(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        return userData['imageUrl'] ?? '';
      } else {
        return 'default';
      }
    } catch (e) {
      print("Error fetching profile image: $e");
      return 'no_image';
    }
  }

  /// Converts the user's profile image URL into a custom marker.
  Future<BitmapDescriptor> createCircularMarker(String imageUrl) async {
    try {
      final http.Response response = await http.get(Uri.parse(imageUrl));
      final Uint8List imageData = response.bodyBytes;

      final ui.Codec codec = await ui.instantiateImageCodec(
        imageData,
        targetWidth: 120,
        targetHeight: 120,
      );

      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      final ui.Image image = frameInfo.image;

      final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);
      final Paint paint = Paint()..isAntiAlias = true;

      const double size = 130;
      const double borderSize = 10;
      const double innerCircleSize = size - borderSize * 2;

      // Draw the border circle
      final Paint borderPaint = Paint()
        ..color = const Color.fromARGB(255, 186, 199, 206)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        const Offset(size / 2, size / 2),
        size / 2,
        borderPaint,
      );

      // Clip the inner circle
      canvas.clipPath(
        Path()
          ..addOval(const Rect.fromLTWH(
              borderSize, borderSize, innerCircleSize, innerCircleSize)),
      );

      // Draw the image inside the circle
      canvas.drawImage(image, const Offset(borderSize, borderSize), paint);

      final ui.Image roundedImage = await pictureRecorder
          .endRecording()
          .toImage(size.toInt(), size.toInt());

      final ByteData? byteData =
          await roundedImage.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List markerBytes = byteData!.buffer.asUint8List();

      return BitmapDescriptor.fromBytes(markerBytes);
    } catch (e) {
      print("Error creating circular marker: $e");
      return BitmapDescriptor.defaultMarker; // Return default marker if error
    }
  }
}
