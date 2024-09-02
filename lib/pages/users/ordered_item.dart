import 'package:flutter/material.dart';

class OrderItems extends StatelessWidget {
  final List products;
  const OrderItems({super.key, required this.products});

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
        body: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            String pname = products[index]['product_name'];
            String price = products[index]['price'];
            String pimage = products[index]['image'];
            String status = products[index]['status']; // User email

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 10, top: 10),
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white70,
                      border:
                          Border.all(color: Color.fromARGB(255, 232, 244, 249)),
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
                                pimage,
                                height: 70,
                                width: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.error),
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                  text: '${pname}\n',
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 25),
                                  children: [
                                    TextSpan(
                                      text: 'Rs.${price}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: RichText(
                            text: TextSpan(
                                text: 'status :\n',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                                children: [
                                  TextSpan(
                                    text: '${status}',
                                    style: TextStyle(
                                      color: status == 'pending'
                                          ? Colors.yellowAccent
                                          : status == 'rejected'
                                              ? Colors.redAccent
                                              : Colors.green,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ));
  }
}
