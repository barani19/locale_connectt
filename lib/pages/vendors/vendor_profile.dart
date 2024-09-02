import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:locale_connectt/pages/users/orderpage.dart';
import 'package:locale_connectt/utils/image_picker.dart';

class VendorProfilePage extends StatefulWidget {
  const VendorProfilePage({super.key});

  @override
  State<VendorProfilePage> createState() => _VendorProfilePageState();
}

class _VendorProfilePageState extends State<VendorProfilePage> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentReference doc =
        FirebaseFirestore.instance.collection('vendors').doc(user!.email);
    var currentuser = doc.get();

    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
            future: currentuser,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }
              var myuser = snapshot.data!.data() as Map<String, dynamic>;
              String image = myuser['shop image'];
              String email = myuser['email'];
              String username = myuser['username'];
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Profile',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Stack(
                      children: [
                        SizedBox(
                          height: 200,
                          width: 200,
                          child: CircleAvatar(
                            foregroundImage: (image.isEmpty || image == null)
                                ? AssetImage('lib/assets/human.jpg')
                                : NetworkImage(image, scale: 10),
                          ),
                        ),
                        Positioned(
                            top: 170,
                            left: 160,
                            child: InkWell(
                              onTap: () async {
                                image = await pickimage();
                                setState(() {});
                                print(image);
                                doc.update({'profile image': image});
                              },
                              child: Icon(
                                Icons.camera_alt,
                                size: 35,
                              ),
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      username.toUpperCase(),
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person, size: 45),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Edit Profile',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          width: 90,
                        ),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 25,
                        )
                      ],
                    ),
                                      
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout, size: 45),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: ()=> FirebaseAuth.instance.signOut(),
                          child: Text(
                            'Sign Out',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
