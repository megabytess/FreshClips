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
  Future<List<Service>> fetchServicesForHairstylist(
      String hairstylistEmail) async {
    _setLoading(true);
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('services')
          .where('hairstylistEmail', isEqualTo: hairstylistEmail)
          .get();

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
    required String hairstylistEmail,
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
        'hairstylistEmail': hairstylistEmail,
      });
      await fetchServicesForHairstylist(hairstylistEmail);
    } catch (e) {
      print('Error adding service: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Update an existing service in Firestore
  Future<void> updateService(Service updatedService) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('services')
          .where('hairstylistEmail', isEqualTo: updatedService.hairstylistEmail)
          .get();
      if (querySnapshot.docs.isEmpty) {
        print('no services found');
      }

      for (var doc in querySnapshot.docs) {
        await doc.reference.update({
          'serviceName': updatedService.serviceName,
          'serviceDescription': updatedService.serviceDescription,
          'price': updatedService.price,
          'duration': updatedService.duration,
        });
      }
      await fetchServicesForHairstylist(updatedService.hairstylistEmail);
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
      await fetchServicesForHairstylist(hairstylistId);
    } catch (e) {
      print('Error deleting service: $e');
    } finally {
      _setLoading(false);
    }
  }
}
