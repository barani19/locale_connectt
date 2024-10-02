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
        List allvend = [];
     QuerySnapshot snapshot = await docref.get();
 for (var element in snapshot.docs) {
        allvend.add({
          'Store name': element.get('Store name'),
          'email': element.get('email'),
          'image': element.get('shop image'),
          'products': element.get('products'),
          'vlat': element.get('vlat'),
          'vlong': element.get('vlong')
        });
        }
    try {
     
  
     
        print('fetching');
        print(allvend);
        locvend = await OpenRouteService()
            .getVendorsWithinThreshold(userLat, userLong, allvend, 3000);
        vendloc = locvend
            .map((element) => [
                  LatLng(element['vlat'], element['vlong']),
                  element['Store name']
                ])
            .toList();
        print('----------${vendloc}');
        print('=========${locvend}');
      }
    catch (e) {
      print('Error fetching locations: $e');
    } finally {
      setLoading = false; // Stop loading
    }
  }
}
