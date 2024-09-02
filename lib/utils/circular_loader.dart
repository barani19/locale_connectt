import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:locale_connectt/Auth/Auth.dart';
import 'package:vector_math/vector_math.dart' show radians;

class FABcircularAnimation extends StatefulWidget {
  const FABcircularAnimation({super.key});

  @override
  State<FABcircularAnimation> createState() => _FABcircularAnimationState();
}

class _FABcircularAnimationState extends State<FABcircularAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
    open() {
    controller.repeat();
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    open();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(Duration(seconds: 7),(){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> AuthService().handleAuthState()));
    });
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,overlays: SystemUiOverlay.values);
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RadialAnimatedMenu(
          controller: controller,
        ),
      ),
    );
  }
}
 // that's it from today video thank you 
class RadialAnimatedMenu extends StatelessWidget {
  final AnimationController controller;
  final Animation<double> scale;
  final Animation<double> translate;
  final Animation<double> rotation;
  RadialAnimatedMenu({super.key, required this.controller})
      : scale = Tween<double>(begin: 1, end: 0.0).animate(
          CurvedAnimation(parent: controller, curve: Curves.linear),
        ),
        translate = Tween<double>(begin: 0.0, end: 110.0).animate(
          CurvedAnimation(parent: controller, curve: Curves.ease),
        ),
        rotation = Tween<double>(begin: 0.0, end: 360.8).animate(
          CurvedAnimation(
              parent: controller,
              curve: const Interval(0.0, 0.8, curve: Curves.bounceIn)),
        );

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, index) {
        return Transform.rotate(
          angle: radians(rotation.value),
          child: Stack(
            alignment: Alignment.center,
            children: [
              itemsButton(0, color: Colors.orange, icon: Icons.home),
              itemsButton(45, color: Colors.purple, icon: Icons.shopping_bag),
              itemsButton(90,
                  color: Colors.indigo, icon: Icons.baby_changing_station),
              itemsButton(135, color: Colors.pink, icon: Icons.cabin),
              itemsButton(180, color: Colors.blue, icon: Icons.dangerous),
              itemsButton(225, color: Colors.grey, icon: Icons.yard_outlined),
              itemsButton(270,
                  color: Colors.deepOrangeAccent, icon: Icons.ice_skating),
              itemsButton(315, color: Colors.orange, icon: Icons.hail_outlined),
             Transform.scale(
                scale: scale.value,
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Center(child: Text('LC',style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.bold),))
                ),
              ),
              Transform.scale(
                scale: scale.value,
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Center(child: Text('LC',style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.bold),))
                ),
              )
            ],
          ),
        );
      },
    );
  }

  itemsButton(double angle, {required Color color, required IconData icon}) {
    final double rad = radians(angle);
    return Transform(
      transform: Matrix4.identity()
        ..translate(
          (translate.value) * cos(rad),
          (translate.value) * sin(rad),
        ),
      child: FloatingActionButton(
        onPressed: close,
        backgroundColor: color,
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }


  close() {
    controller.reverse();
  }
}