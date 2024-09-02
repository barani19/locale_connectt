import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:locale_connectt/helper/helper.dart';
import 'package:locale_connectt/utils/textfield.dart';




class LoginPage extends StatefulWidget {
   final  Function()? onTap;
   const LoginPage({super.key,required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
   TextEditingController email = TextEditingController();
   TextEditingController password = TextEditingController();

   void login()async{
    showDialog(context: context, builder: (context)=>Center(child: CircularProgressIndicator(),));
    
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: password.text);
      if(context.mounted) Navigator.pop(context);
      email.clear();
      password.clear();
    }on FirebaseAuthException catch(e){
      Navigator.pop(context);
      displaymsg(e.code, context);
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
                  Icon(Icons.shopping_cart,size: 100,),
                  SizedBox(height: 20,),
                  Text('L O C A L E - C O N E C T',style: TextStyle(fontSize: 20),),
                  SizedBox(height: 20,),
                  Mytextfield(hint: 'Enter a email', obscuretext: false, controll: email),
                   SizedBox(height: 10,),
                  Mytextfield(hint: 'Enter a password', obscuretext: true, controll: password),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(onPressed: (){}, child: Text('Forget Password?'))),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: Size(double.infinity,40), 
                      ),
                      onPressed: (){
                        login();
                      }, child: Text('Login',style: TextStyle(fontSize: 20),)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Don\'t have an account?',style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),),
                        TextButton(onPressed: widget.onTap, child: Text('Register Here',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)),
                      ],
                    ),
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