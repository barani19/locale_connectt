import 'package:flutter/material.dart';
import 'package:locale_connectt/pages/signin%20and%20signup/loginpage.dart';
import 'package:locale_connectt/pages/signin%20and%20signup/registerpage.dart';



class Loginorreg extends StatefulWidget {
  const Loginorreg({super.key});

  @override
  State<Loginorreg> createState() => _LoginorregState();
}

class _LoginorregState extends State<Loginorreg> {
    bool  isshow = true;

  void changepage(){
   setState(() {
     isshow=!isshow;
   });
  }

  @override
  Widget build(BuildContext context) {
    if(isshow){
      return LoginPage(onTap: changepage);
    }
    else{
      return RegisterPage(onTap: changepage);
    }
  }
}