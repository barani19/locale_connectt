import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:locale_connectt/helper/helper.dart';
import 'package:locale_connectt/utils/textfield.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController userr = TextEditingController();

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  TextEditingController confpassword = TextEditingController();
  TextEditingController storename = TextEditingController();

  double lat = 0;
  double long = 0;

  Future<void> _initializeLocation() async {
    if (await Geolocator.isLocationServiceEnabled() && lat != 0 && long != 0)
      return;
    try {
      Position position = await _determinePosition();
      setState(() {
        lat = position.latitude;
        long = position.longitude;
      });

      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100, // Only update if the user has moved 100 meters
      );

      Geolocator.getPositionStream(locationSettings: locationSettings)
          .listen((Position position) {
        setState(() {
          lat = position.latitude;
          long = position.longitude;
        });
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // If location services are not enabled, request the user to enable them
      await Geolocator.openLocationSettings();
      // Re-check if the location services are enabled
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

  void register() async {
    showDialog(
        context: context,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ));
    if (password.text != confpassword.text) {
      // to remove the circle indicator
      Navigator.pop(context);
      // show the alert msg
      displaymsg('Password doesnt match!!', context);
      // clear all the field
      userr.clear();
      email.clear();
      password.clear();
      confpassword.clear();
    } else {
      try {
        UserCredential? user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: email.text, password: password.text);
        storeuser(user);
        userr.clear();
        email.clear();
        password.clear();
        confpassword.clear();
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        displaymsg(e.toString(), context);
      }
    }
  }

  String? role = 'user';

  Future<void> storeuser(UserCredential? user) async {
    if (user != null && user.user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.user!.email)
          .set({
        'username': userr.text,
        'email': user.user!.email,
        'role': role,
        'password': password.text,
        'ordered': [],
        'profile image': 'https://firebasestorage.googleapis.com/v0/b/new-conect-ca7f0.appspot.com/o/images%2Fhuman.jpg?alt=media&token=b736d563-5221-40aa-865a-17743c65c11f'
      });

      if (role == 'vendor') {
        await FirebaseFirestore.instance
            .collection('vendors')
            .doc(user.user!.email)
            .set({
          'Store name': storename.text,
          'username': userr.text,
          'email': user.user!.email,
          'role': role,
          'password': password.text,
          'vlat': lat,
          'vlong': long,
          'orders': [],
          'products': [],
          'shop image': 'https://firebasestorage.googleapis.com/v0/b/new-conect-ca7f0.appspot.com/o/images%2Fhuman.jpg?alt=media&token=b736d563-5221-40aa-865a-17743c65c11f'
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart,
                    size: 50,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'L O C A L E - C O N E C T',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Mytextfield(
                      hint: 'Enter a user name',
                      obscuretext: false,
                      controll: userr),
                  SizedBox(
                    height: 20,
                  ),
                  Mytextfield(
                      hint: 'Enter a email',
                      obscuretext: false,
                      controll: email),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                    ),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10)),
                      child: DropdownButton(
                        hint: Text('Choose a role'),
                        underline: SizedBox(),
                        borderRadius: BorderRadius.circular(10),
                        padding: EdgeInsets.all(10),
                        value: role,
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(value: 'user', child: Text('User')),
                          DropdownMenuItem(
                              value: 'vendor', child: Text('Vendor')),
                        ],
                        onChanged: (String? value) {
                          setState(() {
                            role = value;
                          });
                        },
                      ),
                    ),
                  ),
                  if (role == 'vendor') ...[
                    SizedBox(
                      height: 10,
                    ),
                    Mytextfield(
                        hint: 'Store name',
                        obscuretext: false,
                        controll: storename),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('choose your location'),
                          ElevatedButton(
                              onPressed: () {
                                _initializeLocation();
                                print(lat);
                                print(long);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: (lat != 0 && long != 0)
                                        ? Text('location added successfully')
                                        : Text(
                                            'location is not fetched try again')));
                              },
                              child: Text('Location')),
                        ],
                      )),
                    )
                  ],
                  SizedBox(
                    height: 10,
                  ),
                  Mytextfield(
                      hint: 'Enter a password',
                      obscuretext: true,
                      controll: password),
                  SizedBox(
                    height: 20,
                  ),
                  Mytextfield(
                      hint: 'Confirm Password',
                      obscuretext: true,
                      controll: confpassword),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: Size(double.infinity, 40),
                        ),
                        onPressed: () {
                          register();
                        },
                        child: Text(
                          'Register',
                          style: TextStyle(fontSize: 20),
                        )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                          onPressed: widget.onTap,
                          child: Text(
                            'Login Here',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
