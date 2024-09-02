import 'package:flutter/material.dart';

class Mytextfield extends StatelessWidget {
  final String hint;
  final bool obscuretext;
  final TextEditingController controll;
  const Mytextfield({
    super.key,
    required this.hint,
    required this.obscuretext,
    required this.controll  
    });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20,right: 20),
      child: TextField(
        controller: controll,
        obscureText: obscuretext,
         decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.black
            )
          )
         ),
      ),
    );
  }
}