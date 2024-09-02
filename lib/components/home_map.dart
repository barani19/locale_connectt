import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';

class MyMap extends StatefulWidget {
  final List<dynamic> marker; // List of vendor markers
  final LatLng user; // User marker LatLng
  const MyMap({super.key, required this.marker, required this.user});

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  final PopupController _popupLayerController = PopupController();

  List<Marker> mymarker = [];

  @override
  Widget build(BuildContext context) {
    // Combine user and vendor markers into a single list
    List<List<dynamic>> all = [
      [widget.user, 'user'],
      ...widget.marker
    ];

    // Create markers based on the combined list
    mymarker = all.map((entry) {
      String type = entry[1]; // 'user' or 'vendor'
      LatLng position = entry[0]; // LatLng object
      return Marker(
        point: position,
        height: 50,
        width: 50,
        child: Icon(
          Icons.location_on,
          color: type == 'user'
              ? Colors.green
              : Colors.red, // Different color for user and vendor
          size: type == 'user' ? 50 : 30,
        ),
      );
    }).toList();

    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: FlutterMap(
        options: MapOptions(
          initialCenter:
              widget.user, // Use user's LatLng for initial map center
          initialZoom: 14.5,
          interactionOptions:
              InteractionOptions(flags: ~InteractiveFlag.doubleTapZoom),
        ),
        children: [
          openstreetmaptilelate,
          PopupMarkerLayer(
            options: PopupMarkerLayerOptions(
              markers: mymarker,
              popupController: _popupLayerController,
              popupDisplayOptions: PopupDisplayOptions(
                snap: PopupSnap.markerTop,
                builder: (BuildContext context,Marker marker){
                  final  current = mymarker.indexOf(marker);
                  final  fetch = all[current];
                  final text = fetch[1];
                  return  Container(
                  color: Colors.white,
                  child: Text(
                    text,
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  ),
                );
                }
              ),
            ),
          ),
        ],
      ),
    );
  }
}

TileLayer get openstreetmaptilelate => TileLayer(
      urlTemplate: 'http://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
    );
