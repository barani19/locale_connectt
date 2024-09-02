import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:locale_connectt/Auth/map_provider.dart';
import 'package:locale_connectt/pages/users/Shop.dart';
import 'package:locale_connectt/components/home_map.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Cushome extends StatefulWidget {
  Cushome({super.key});

  @override
  State<Cushome> createState() => _CushomeState();
}

class _CushomeState extends State<Cushome> {
  final TextEditingController search = TextEditingController();
  bool isshow = false;

  Future<void> _initializeLocation() async {
    var mapprovider = Provider.of<MapProvider>(context, listen: false);
    try {
      mapprovider.setLoading = true;

      Position position = await _determinePosition();

      mapprovider.setLat = position.latitude;
      mapprovider.setLong = position.longitude;

      await mapprovider.fetchAndSortLocations();

      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );

      Geolocator.getPositionStream(locationSettings: locationSettings)
          .listen((Position position) async {
        if (position.latitude != mapprovider.userLat ||
            position.longitude != mapprovider.userLong) {
          mapprovider.setLat = position.latitude;
          mapprovider.setLong = position.longitude;

          await mapprovider.fetchAndSortLocations();
        }
      });
      mapprovider.setLoading = false;
    } catch (e) {
      mapprovider.setLoading = false;
      print('Error getting location: $e');
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  @override
  Widget build(BuildContext context) {
    // CollectionReference reference =
    //     FirebaseFirestore.instance.collection('vendors');
    // Stream<QuerySnapshot> stream = reference.snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'LC',
          style: TextStyle(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 30),
        ),
        centerTitle: true,
        elevation: 0,
        forceMaterialTransparency: true,
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       FirebaseAuth.instance.signOut();
        //     },
        //     icon: Icon(Icons.logout),
        //   ),
        // ],
      ),
      backgroundColor: Color.fromARGB(255, 251, 247, 247),
      body: // Show loading indicator
          SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Consumer<MapProvider>(
            builder: (context, mapprovider, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                (mapprovider.userLat != 0 &&
                        mapprovider.userLong != 0 &&
                        !mapprovider.loading)
                    ? MyMap(
                        marker: mapprovider.vendorLoc,
                        user: LatLng(mapprovider.userLat, mapprovider.userLong),
                      )
                    : LottieBuilder.asset(
                        'lib/assets/Lottie/Animation - 1724827286415.json'),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      fixedSize: Size(250, 50),
                    ),
                    onPressed: () {
                      print(mapprovider.loading);
                      if (!mapprovider.loading) _initializeLocation();
                    },
                    child: Text(
                      'pick current location',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    )),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Shops near to you',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
                (mapprovider.userLat != 0 && mapprovider.userLong != 0)
                    ? Expanded(
                        child: GridView.builder(
                        itemCount: mapprovider.locvend.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        itemBuilder: (context, index) {
                          final name = mapprovider.locvend[index]['Store name'];
                          final image = mapprovider.locvend[index]['image'];
                          final curentshop = mapprovider.locvend[index];
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ShopApp(shop: curentshop)),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      image,
                                      height: 130,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.error),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15.0, top: 5),
                                child: Text(
                                  name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 2, 52, 94),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ))
                    : Text('No data found')
              ],
            ),
          ),
        ),
        bottom: false,
      ),
    );
  }
}
