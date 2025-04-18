import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/hairstylist-features/models/services_model.dart';

class ServiceController with ChangeNotifier {
  List<Service> services = [];
  bool isLoading = false;

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  // Fetch services for a specific hairstylist from Firestore
  Future<List<Service>> fetchServicesForUsers(String userEmail) async {
    _setLoading(true);
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('services')
          .where('userEmail', isEqualTo: userEmail)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('No documents found for user: $userEmail');
      } else {
        print('Documents fetched: ${querySnapshot.docs.length}');
      }

      services =
          querySnapshot.docs.map((doc) => Service.fromDocument(doc)).toList();
      return services;
    } catch (e) {
      print('Error fetching services: $e');
      return [];
    } finally {
      _setLoading(false);
    }
  }

  // Add a new service to Firestore
  Future<void> addService({
    required String userEmail,
    required String serviceName,
    required String serviceDescription,
    required double price,
    required int duration,
  }) async {
    try {
      _setLoading(true);
      await FirebaseFirestore.instance.collection('services').add({
        'serviceName': serviceName,
        'serviceDescription': serviceDescription,
        'price': price,
        'duration': duration,
        'userEmail': userEmail,
      });
      await fetchServicesForUsers(userEmail);
    } catch (e) {
      print('Error adding service: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Update an existing service in Firestore
  Future<void> updateService(Service updatedService) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('services')
          .doc(updatedService.id);

      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        print('Service not found');
        return;
      }

      // Update only the matching service
      await docRef.update({
        'serviceName': updatedService.serviceName,
        'serviceDescription': updatedService.serviceDescription,
        'price': updatedService.price,
        'duration': updatedService.duration,
      });

      await fetchServicesForUsers(updatedService.userEmail);
    } catch (e) {
      print('Error updating service: $e');
    }
  }

  // Delete a service from Firestore
  Future<void> deleteService(String serviceId, String hairstylistId) async {
    try {
      _setLoading(true);
      await FirebaseFirestore.instance
          .collection('services')
          .doc(serviceId)
          .delete();
      await fetchServicesForUsers(hairstylistId);
    } catch (e) {
      print('Error deleting service: $e');
    } finally {
      _setLoading(false);
    }
  }
}
