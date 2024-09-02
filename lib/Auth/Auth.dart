import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:locale_connectt/Auth/rolebased.dart';
import 'package:locale_connectt/pages/signin%20and%20signup/loginorreg.dart';

class AuthService {
  // Handle Auth
  handleAuthState() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return Rolebased();
        } else {
          return Loginorreg();
        }
      },
    );
  }
}

