import 'package:flutter/material.dart';
import 'package:locale_connectt/pages/vendors/chart/bar_charts.dart';
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var currentPage = DrawerSections.barchart;

  @override
  Widget build(BuildContext context) {
    var container;
    if (currentPage == DrawerSections.barchart) {
      container = BarCharts();
    }

    return Scaffold(
        appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Chart Analysis',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
        body: container,
        );
   }

  Widget MyDrawerList() {
    return Column(
      children: [
        menuItem(1, "Bar Chart", Icons.bar_chart,
            currentPage == DrawerSections.barchart ? true : false),
      ],
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            if (id == 1) {
              currentPage = DrawerSections.barchart;
            }
          });
        },
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.black,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum DrawerSections {
  barchart,
}
