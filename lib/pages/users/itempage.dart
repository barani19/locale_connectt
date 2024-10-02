// import 'dart:math';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:locale_connectt/helper/api.dart';
// import 'package:locale_connectt/pages/users/cartitem.dart';

// class ItemPage extends StatefulWidget {
//   final String iname;
//   final  double? lat;
//   final double? long;
//   ItemPage({Key? key, required this.iname,required this.lat,required this.long}) : super(key: key);

//   @override
//   _ItemPageState createState() => _ItemPageState();
// }

// class _ItemPageState extends State<ItemPage> {
//   Future<List<Map<String, dynamic>>> fetchAndSortLocations(List<dynamic> products) async {
//     List<Map<String, dynamic>> locations = [];

//     for (var product in products) {
//       var data = product as Map<String, dynamic>;
//       if (data['iname'].toString().toLowerCase() == widget.iname.toLowerCase() &&
//           data['ilat'] != null && data['ilong'] != null && data['iimage'] != null) {

//         double ilat = double.tryParse(data['ilat'].toString()) ?? 0.0;
//         double ilong = double.tryParse(data['ilong'].toString()) ?? 0.0;
//        print(widget.lat!);
//        print(widget.long!);
//        print(ilat);
//        print(ilong);
//         double distance = await OpenRouteService().getDistance(widget.lat!, widget.long!, ilat, ilong);
//         print(distance);

//         if(distance == -1) continue;

//         locations.add({
//           'email': data['email'],
//           'iname': data['iname'],
//           'image': data['iimage'],
//           'price': data['iprice'],
//           'Store name': data['Store name'],
//           'location': Location(ilat, ilong),
//           'distance': distance
//         });
//       }
//     }

//     // Sort locations by distance after fetching all distances
//     locations.sort((a, b) => a['distance'].compareTo(b['distance']));
//     print(locations);
//     return locations;
//   }

//   @override
//   Widget build(BuildContext context) {
//     CollectionReference reference = FirebaseFirestore.instance.collection('vendors');
//     Stream<QuerySnapshot> stream = reference.snapshots();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Item',
//           style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 30),
//         ),
//         centerTitle: true,
//       ),
//       body: StreamBuilder(
//         stream: stream,
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Unable to fetch data..'));
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text('No data available.'));
//           }

//           List<DocumentSnapshot> plist = snapshot.data!.docs;
//           List<dynamic> products = [];

//           for (var document in plist) {
//             String? email = document['email'];
//             String snames = document['Store name'];
//             if (document['products'] != null) {
//               var productList = document['products'] as List<dynamic>;
//               for (var product in productList) {
//                 if (product is Map<String, dynamic>) {
//                   products.add({
//                     ...product,
//                     'email': email,
//                     'Store name': snames,
//                   });
//                 }
//               }
//             }
//           }
         
//           return FutureBuilder<List<Map<String, dynamic>>>(
//             future: fetchAndSortLocations(products),
//             builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> locationSnapshot) {
//               if (locationSnapshot.connectionState == ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//               }
//               if (locationSnapshot.hasError) {
//                 return Center(child: Text('Error fetching distances.'));
//               }
//               if (!locationSnapshot.hasData || locationSnapshot.data!.isEmpty) {
//                 return Center(child: Text('Sorry! The product doesnt available near to you.'));
//               }

//               List<Map<String, dynamic>> locations = locationSnapshot.data!;
              

//               return Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: ListView.builder(
//                   itemCount: locations.length,
//                   itemBuilder: (context, index) {
//                     var locationData = locations[index];
//                     String price = locationData['price'];
//                     Location location = locationData['location'];
//                     String imageUrl = locationData['image'];
//                     String email = locationData['email'] ?? 'No email available';
//                     String Storename = locationData['Store name'];

//                     return GestureDetector(
//                       onTap: () => Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (_) => Cartitem(
//                             pimage: imageUrl,
//                             pname: locationData['iname'],
//                             price: price,
//                             email: email,
//                             lat: location.latitude,
//                             long: location.longitude,
//                             product: products,
//                           ),
//                         ),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: Colors.white70,
//                             border: Border.all(color: Color.fromARGB(255, 232, 244, 249)),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Color.fromARGB(255, 210, 207, 207),
//                                 spreadRadius: 1,
//                                 blurRadius: 5,
//                               )
//                             ],
//                           ),
//                           child: ListTile(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             tileColor: Color.fromARGB(255, 237, 229, 238),
//                             leading: imageUrl.isNotEmpty ? Image.network(imageUrl, height: 100, width: 100, fit: BoxFit.cover) : null,
//                             title: Text(Storename),
//                             subtitle: Text(email),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }


// class Location {
//   double latitude;
//   double longitude;

//   Location(this.latitude, this.longitude);
// }

// // Calculate the distance between two points using the Haversine formula
// double haversineDistance(Location loc1, Location loc2) {
//   const double R = 6371; // Radius of the Earth in km
//   double latDistance = (loc2.latitude - loc1.latitude) * pi / 180;
//   double lonDistance = (loc2.longitude - loc1.longitude) * pi / 180;
//   double a = sin(latDistance / 2) * sin(latDistance / 2) +
//       cos(loc1.latitude * pi / 180) * cos(loc2.latitude * pi / 180) *
//       sin(lonDistance / 2) * sin(lonDistance / 2);
//   double c = 2 * atan2(sqrt(a), sqrt(1 - a));
//   return R * c; // Distance in km
// }



