import 'package:flutter/material.dart';

void displaymsg(String msg,BuildContext context){
   showDialog(context: context, builder: (context)=> AlertDialog(content: Text(msg),));
}