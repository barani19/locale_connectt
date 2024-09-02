import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:locale_connectt/pages/users/profile.dart';
import 'package:locale_connectt/pages/users/Vendor.dart';
import 'package:locale_connectt/pages/users/cartpage.dart';
import 'package:locale_connectt/pages/users/cushome.dart';
import 'package:locale_connectt/pages/vendors/vendor_orderpage.dart';
import 'package:locale_connectt/pages/vendors/home.dart';
import 'package:locale_connectt/pages/signin%20and%20signup/loginorreg.dart';
import 'package:locale_connectt/pages/vendors/chart/main_screen.dart';
import 'package:locale_connectt/pages/vendors/orders.dart';
import 'package:locale_connectt/pages/vendors/vendor_profile.dart';
import 'package:locale_connectt/utils/bottom.dart';

class Rolebased extends StatelessWidget {
  const Rolebased({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('users').doc(user?.email).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData && snapshot.data != null) {
          var userData = snapshot.data?.data() as Map<String, dynamic>;
          if (userData.containsKey('role')) {
            var role = userData['role'];
            if (role == 'vendor') {
              return Bottom(
                  i1: Icons.home,
                  i2: Icons.auto_graph,
                  i3: Icons.shop,
                  i4: Icons.person,
                  s1: 'Analysis',
                  s2: 'vorders',
                  s3: 'profile',
                  screen: [
                    Home(),
                    MainScreen(),
                    VendorOrderPage(),
                    VendorProfilePage()
                  ]);
            } else if (role == 'user') {
              return Bottom(
                i1: Icons.home,
                i2: Icons.shopping_cart,
                i3: Icons.shop,
                i4: Icons.person,
                s1: 'cart',
                s2: 'vendor',
                s3: 'profile',
                screen: [Cushome(), CartPage(), VendorPage(), ProfilePage()],
              );
            } else {
              return Loginorreg();
            }
          }
        }
        return Center(
          child: Text('unknown error'),
        );
      },
    );
  }
}
