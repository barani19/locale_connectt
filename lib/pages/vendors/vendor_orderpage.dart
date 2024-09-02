import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:locale_connectt/pages/vendors/orders.dart';

class VendorOrderPage extends StatelessWidget {
  const VendorOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    String extractDateTime(Timestamp timestamp) {
      // Convert the Timestamp to a DateTime object
      DateTime dateTime = timestamp.toDate();

      // Extract the date
      String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

      // Extract the time
      String formattedTime = DateFormat('HH:mm:ss').format(dateTime);

      return formattedDate + ' ' + formattedTime;
    }

    User? user = FirebaseAuth.instance.currentUser;
    DocumentReference userdoc =
        FirebaseFirestore.instance.collection('vendors').doc(user?.email);
    Stream<DocumentSnapshot> stream = userdoc.snapshots();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 244, 243, 243),
      appBar: AppBar(
        title: Text(
          'Order Page',
          style: TextStyle(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Unable to fetch data'));
          }
          if (snapshot.hasData) {
            var documents = snapshot.data!.data() as Map<String, dynamic>;
            List orders = documents['orders'];
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                var item = orders[index];
                String datetime = extractDateTime(orders[index]['order_date']);
                if (orders[index]['products'].length > 1) {}
                // Check if 'ordered' field exists and is a list
                if (orders.length > 0) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => VendorOrderItems(
                                    orderIndex: index,
                                  ))),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                  text: 'Ordered by : ',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                  children: [
                                    TextSpan(
                                      text: item['user_id'],
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ]),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // If there are more than 1 product, show the first two images
                                Wrap(
                                  children: [
                                    if (orders[index]['products'].length >
                                        1) ...[
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                          orders[index]['products'][0]['image'],
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.fill,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Icon(Icons.error),
                                        ),
                                      ),
                                      SizedBox(
                                          width:
                                              5), // Add some spacing between images
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                          orders[index]['products'][1]['image'],
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.fill,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Icon(Icons.error),
                                        ),
                                      ),
                                      Text(
                                        '\n+${orders[index]['products'].length - 2} more....',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10),
                                      ),
                                    ]
                                    // Otherwise, show only the first image
                                    else ...[
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                          orders[index]['products'][0]['image'],
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.fill,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Icon(Icons.error),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                RichText(
                                  text: TextSpan(
                                      text: 'cancel at:\n',
                                      style: TextStyle(
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.bold),
                                      children: [
                                        TextSpan(
                                            text: '${datetime}',
                                            style:
                                                TextStyle(color: Colors.black))
                                      ]),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                                child: Text(
                              item['order status'],
                              style: TextStyle(
                                  color: item['order status'] == 'canceled'
                                      ? Colors.redAccent
                                      : Colors.yellowAccent),
                            )),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text('No orders found'),
                    ),
                  );
                }
              },
            );
          }
          return Center(child: Text('No data available'));
        },
      ),
    );
  }
}
