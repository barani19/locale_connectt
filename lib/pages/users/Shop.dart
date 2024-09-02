import 'package:flutter/material.dart';
import 'package:locale_connectt/pages/users/cartitem.dart';

class ShopApp extends StatelessWidget {
   var shop;
  ShopApp({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    print(shop);
    List product = shop['products'];
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '${shop['Store name']}',
            style: TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 30),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns
            childAspectRatio: 0.8, // Adjust the aspect ratio as needed
          ),
          itemCount: product.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> data = product[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Cartitem(
                            email: shop['email'] as String,
                            pimage: data['iimage'] as String,
                            lat: double.parse(data['ilat']),
                            long: double.parse(data['ilong']),
                            pname: data['iname'] as String,
                            price: data['iprice'] as String,
                            product: product,
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        '${data['iimage']}',
                        height: 130,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, top: 5),
                      child: Text(
                        '${data['iname']}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color.fromARGB(255, 2, 52, 94)),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, top: 0),
                      child: Text(
                        'Rs.${data['iprice']}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color.fromARGB(255, 44, 16, 203)),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
