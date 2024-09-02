import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VendorOrderItems extends StatelessWidget {
  final int orderIndex;

  const VendorOrderItems({
    super.key,
    required this.orderIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Orders',
          style: TextStyle(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 30),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('vendors')
            .doc(FirebaseAuth.instance.currentUser!.email)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasData && snapshot.data!.exists) {
            var vendorData = snapshot.data!.data() as Map<String, dynamic>;
            List orders = vendorData['orders'] ?? [];

            if (orderIndex >= orders.length) {
              return Text('Order not found');
            }

            Map<String, dynamic> order = orders[orderIndex];
            List products = order['products'] ?? [];
            String vendorId = order['vendor_id'];
            String useremail = order['user_id'];

            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                String pname = products[index]['product_name'];
                String price = products[index]['price'];
                String status = products[index]['status'];
                String qty = products[index]['quantity'].toString();

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 10, top: 10),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white70,
                          border: Border.all(
                              color: Color.fromARGB(255, 232, 244, 249)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Wrap(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 8, left: 8, right: 10),
                                  child: Image.network(
                                    products[index]['image'],
                                    height: 70,
                                    width: 70,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Icon(Icons.error),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                          text: '${pname}\n',
                                          style: TextStyle(
                                              color: Colors.blue, fontSize: 25),
                                          children: [
                                            TextSpan(
                                              text: 'Rs.${price}    ',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'qty : ${qty}',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ]),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            'Status: $status',
                                            style: TextStyle(fontSize: 17),
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              for (int i = 0;
                                                  i < orders.length;
                                                  i++) {
                                                if (orderIndex == i) {
                                                  orders[i]['products'][index]
                                                      ['status'] = 'accepted';
                                                }
                                              }

                                              await FirebaseFirestore.instance
                                                  .collection('vendors')
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser!.email)
                                                  .update({
                                                'orders': orders,
                                              });

                                              // Update the corresponding user's order
                                              await _updateUserOrderStatus(
                                                  useremail,
                                                  vendorId,
                                                  pname,
                                                  price,
                                                  'accepted',
                                                  extractDateTime(
                                                      order['order_date']));
                                            },
                                            icon: Icon(Icons.check),
                                            color: Colors.green,
                                            iconSize: 25,
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              for (int i = 0;
                                                  i < orders.length;
                                                  i++) {
                                                if (orderIndex == i) {
                                                  orders[i]['products'][index]
                                                      ['status'] = 'rejected';
                                                }
                                              }

                                              // Update the specific product's status in Firestore
                                              await FirebaseFirestore.instance
                                                  .collection('vendors')
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser!.email)
                                                  .update({
                                                'orders': orders,
                                              });

                                              // Update the corresponding user's order
                                              await _updateUserOrderStatus(
                                                  useremail,
                                                  vendorId,
                                                  pname,
                                                  price,
                                                  'rejected',
                                                  extractDateTime(
                                                      order['order_date']));
                                            },
                                            icon: Icon(Icons.cancel_outlined),
                                            color: Colors.red,
                                            iconSize: 25,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }

          return Text('No Data');
        },
      ),
    );
  }

  // Function to update the user's order status
  Future<void> _updateUserOrderStatus(String userEmail, String vendorId,
      String pname, String price, String newStatus, String datetime) async {
    // Fetch the user document from Firestore
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .get();

    List userOrders = userDoc['ordered'] ?? [];

    // Find the corresponding order and product in the user's orders
    for (var order in userOrders) {
      // Compare the Timestamp objects
      if (extractDateTime(order['order_date']) == datetime &&
          order['vendor_id'] == vendorId) {
        print('hello');
        List userProducts = order['products'];
        for (var userProduct in userProducts) {
          if (userProduct['product_name'] == pname &&
              userProduct['price'] == price) {
            userProduct['status'] = newStatus;
            print(userOrders);
            break;
          }
        }
        break;
      }
    }
    // Update Firestore for the user
    await FirebaseFirestore.instance.collection('users').doc(userEmail).update({
      'ordered': userOrders,
    });
  }
}

String extractDateTime(Timestamp timestamp) {
  // Convert the Timestamp to a DateTime object
  DateTime dateTime = timestamp.toDate();

  // Extract the date
  String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

  // Extract the time
  String formattedTime = DateFormat('HH:mm:ss').format(dateTime);

  return formattedDate + ' ' + formattedTime;
}
