
import 'package:flutter/material.dart';
import 'package:locale_connectt/pages/vendors/chart/chart.dart';
import 'package:locale_connectt/pages/vendors/chart/constants.dart';

class BarCharts extends StatelessWidget {
  const BarCharts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Chart()
            ],
          ),
        ),
      ),
    );
  }
}
