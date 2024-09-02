import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:locale_connectt/helper/api.dart';

class MapProvider extends ChangeNotifier {
  double lat = 0;
  double long = 0;
  bool isLoading = false;
  List vendloc = [];
  List<Map<String, dynamic>> locvend = [];

  // Firebase Firestore reference
  final CollectionReference docref =
      FirebaseFirestore.instance.collection('vendors');

  // Setters
  set setLat(double lat) {
    this.lat = lat;
    notifyListeners();
  }

  set setLong(double long) {
    this.long = long;
    notifyListeners();
  }

  set setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  // Getters
  double get userLat => lat;
  double get userLong => long;
  bool get loading => isLoading;
  List get vendorLoc => vendloc;
  List<Map<String, dynamic>> get nearbyVendor => locvend;

  // Method to fetch and sort locations
  Future<void> fetchAndSortLocations() async {
    setLoading = true; // Start loading
    vendloc = [];
    locvend = [];

    try {
      QuerySnapshot snapshot = await docref.get();
      for (var element in snapshot.docs) {
        print('fetching');
        double distance = await OpenRouteService()
            .getDistance(lat, long, element.get('vlat'), element.get('vlong'));
        if (distance != -1 && distance < 6000) {
          vendloc.add([
            LatLng(element.get('vlat'), element.get('vlong')),
            element.get('Store name')
          ]);
          locvend.add({
            'Store name': element.get('Store name'),
            'email': element.get('email'),
            'image': element.get('shop image'),
            'products': element.get('products')
          });
        }
      }
      print('fetched');
    } catch (e) {
      print('Error fetching locations: $e');
    } finally {
      setLoading = false; // Stop loading
    }
  }
}
