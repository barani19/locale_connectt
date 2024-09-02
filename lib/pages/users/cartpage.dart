import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:locale_connectt/Auth/cartprovider.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> getUserDetails() async {
    try {
      // Reference to the "vendors" collection
      CollectionReference vendors =
          FirebaseFirestore.instance.collection('vendors');

      // Fetch all documents in the collection
      QuerySnapshot snapshot = await vendors.get();

      // Loop through the documents and access data
      snapshot.docs.forEach((doc) {
        print('User ID: ${doc.id}');
        print('User Data: ${doc.data()}');
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    double total = Provider.of<Cartprovider>(context, listen: false).money;
    var mycart = Provider.of<Cartprovider>(context).cart;
    var mycartpdt = [];
    Provider.of<Cartprovider>(context).cart.values.forEach(
      (element) {
        mycartpdt.addAll(element);
      },
    );

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'My Cart',
            style: TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 30),
          ),
          centerTitle: true,
        ),
        body: Stack(children: [
          ListView.builder(
            itemCount: mycartpdt.length,
            itemBuilder: (context, index) {
              var item = mycartpdt.elementAt(index);

              print('-----${item}');
              String panme = mycartpdt.elementAt(index)['pname'];
              String pimage = mycartpdt.elementAt(index)['pimage'];
              String price = mycartpdt.elementAt(index)['price'];
              String vemail = mycartpdt.elementAt(index)['vemail'];
              int qty = mycartpdt.elementAt(index)['qty'];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(70),
                    child: Image.network(
                      pimage,
                      height: 80,
                      width: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.error),
                    ),
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Remvoe'),
                              content: Text('Are u sure want to delete?'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'No',
                                      style: TextStyle(color: Colors.green),
                                    )),
                                TextButton(
                                    onPressed: () {
                                      Provider.of<Cartprovider>(context,
                                              listen: false)
                                          .removemoney(
                                              double.parse(price) * qty);
                                      total = Provider.of<Cartprovider>(context,
                                              listen: false)
                                          .money;
                                      Provider.of<Cartprovider>(context,
                                              listen: false)
                                          .removeproduct(item, vemail);
                                      Navigator.pop(context);
                                      print(mycart);
                                      print(total);
                                    },
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(color: Colors.red),
                                    )),
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 30,
                      )),
                  title: Text(
                    panme,
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  subtitle: Row(children: [
                    Text(
                      'Rs.$price   |',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Qty : ${qty}',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    )
                  ]),
                ),
              );
            },
          ),
          Positioned(
            bottom: 90,
            right: 1,
            left: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(255, 56, 56, 56), blurRadius: 5)
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
                padding: EdgeInsets.only(top: 15, left: 20),
                height: 100,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        'TOTAL: Rs.$total',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            print(mycart);
                            for (var vendorId in mycart.keys) {
                              DocumentReference vendorRef = FirebaseFirestore
                                  .instance
                                  .collection('vendors')
                                  .doc(vendorId);
                              DocumentSnapshot vendorDocSnapshot =
                                  await vendorRef.get();

                              // Ensure 'orders' is a list of maps, not arrays of arrays for vendors
                              List<dynamic> vendorOrders =
                                  vendorDocSnapshot.get('orders') ?? [];

                              // Create a list to hold all products for this vendor
                              List<Map<String, dynamic>> productsForVendor = [];

                              // Loop through the products for the current vendor and add them to the list
                              mycart[vendorId].forEach((product) {
                                productsForVendor.add({
                                  'product_name': product['pname'],
                                  'quantity': product['qty'],
                                  'price': product['price'],
                                  'image': product['pimage'],
                                  'status': product['status']
                                  // Add more fields if necessary
                                });
                              });

                              // Create a new order entry for this vendor
                              Map<String, dynamic> orderForVendor = {
                                'vendor_id': vendorId,
                                'user_id': user!.email,
                                'products': productsForVendor,
                                'ordered on': vendorDocSnapshot['Store name'],
                                'order status': 'pending',
                                'order_date': DateTime
                                    .now(), // Include additional information like the order date
                              };

                              // Add the new order entry to the vendor's current orders
                              vendorOrders.add(orderForVendor);
                               print(vendorOrders);
                              // Update the vendor document with the new list of orders
                              await vendorRef.update({
                                'orders': vendorOrders,
                              });

                              // Now update the user's collection
                              DocumentReference userRef = FirebaseFirestore
                                  .instance
                                  .collection('users')
                                  .doc(user!.email);
                              DocumentSnapshot userDocSnapshot =
                                  await userRef.get();

                              // Ensure 'orders' is a list of maps, not arrays of arrays for users
                              List<dynamic> userOrders =
                                  userDocSnapshot.get('ordered') ?? [];

                              // Add the same order entry to the user's orders
                              userOrders.add(
                                  orderForVendor); // Use the same order structure

                              // Update the user document with the new list of orders
                              await userRef.update({
                                'ordered': userOrders,
                              });
                            }

// Optionally clear the cart after processing the orders

                            Provider.of<Cartprovider>(context, listen: false)
                                .removeall();
                          },
                          child: Text('Order now')),
                    ),
                  ],
                ),
              ),
            ),
          )
        ]));
  }
}
