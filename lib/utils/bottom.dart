import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class Bottom extends StatefulWidget {
  final IconData i1 ;
  final IconData i2;
  final IconData i3;
  final IconData i4;
  String s1;
  String s2;
  String s3;
    List<Widget> screen = [];
   Bottom({super.key,required this.screen,required this.i1,required this.i2,required this.i3,required this.i4,required this.s1,required this.s2,required this.s3});

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
      int currentItem =0;
       late List<SalomonBottomBarItem> item;
     @override
  void initState() {
    super.initState();
    item = [
      SalomonBottomBarItem(icon: Icon(widget.i1), title: const Text("Home"),selectedColor:  Color.fromARGB(255, 247, 8, 175)),
      SalomonBottomBarItem(icon:  Icon(widget.i2), title:  Text(widget.s1),selectedColor:  Color.fromARGB(255, 247, 8, 8)),
      SalomonBottomBarItem(icon:  Icon(widget.i3), title:  Text(widget.s2),selectedColor:  Color.fromARGB(255, 8, 247, 60)),
      SalomonBottomBarItem(icon:  Icon(widget.i4), title:  Text(widget.s3),selectedColor:  Color.fromARGB(255, 48, 8, 247))
    ];
  }

  @override
  Widget build(BuildContext context) {
  
    return  MaterialApp(
      home: Scaffold(
        body: widget.screen[currentItem],
        extendBody: true,
          bottomNavigationBar: Card(
            
            color:  Colors.white,
            elevation: 20,
            margin: const EdgeInsets.all(16),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
            child: SalomonBottomBar(
              items: item,
              backgroundColor: Colors.transparent,
              currentIndex: currentItem,
              onTap: (index) => {
                setState(() {
                  currentItem = index;
              },)}
              ),
          ),
      ),
    );
  }
}