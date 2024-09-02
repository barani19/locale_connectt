import 'package:flutter/material.dart';
import 'package:locale_connectt/pages/vendors/chart/constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Chart extends StatefulWidget {
  const Chart({super.key});
  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  String Selectedchips= "Dec";
  List<String> chips=["Oct","Nov","Dec","Jan","Feb","Mar"];
  

  
  @override
  Widget build(BuildContext context) {
    return Card(
        color: secondaryColor,
        surfaceTintColor: secondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding,vertical: defaultPadding),
          child: Column(
            children: [
              Row(children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      Text('Column Chart',style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700
                      ),)
                    ],
                  ),
                ),
                SizedBox(width: defaultPadding *2),
                Expanded(
                  flex: 2 ,
                  child: Image.asset('lib/assets/graph.jpeg')),
                
                
              ],
              ),
              FittedBox(
                  child: Wrap(
                    spacing: 10,
                    children: chips.map((Category){
                        return ChoiceChip(
                          label: Text(Category),
                          labelStyle: TextStyle(color: Colors.black),
                          selectedColor: Colors.amber,
                          backgroundColor: Colors.deepPurple,
                          showCheckmark: false, 
                          selected: Selectedchips.contains(Category),
                          side: BorderSide(width: 0,color: Colors.white) ,
                          shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          onSelected: (isSelected){
                                  setState(() {
                                    if (isSelected){
                                      Selectedchips=Category;
                                    }
                                  });
                          },
                          );
                    }).toList(),
                  
                  ),
                ),
                SfCartesianChart(
                  margin: EdgeInsets.symmetric(vertical: defaultPadding*2),
                  borderWidth: 0,
                  plotAreaBorderWidth: 0,
                  primaryXAxis: CategoryAxis(
                    isVisible: false,
                  ),
                  primaryYAxis: NumericAxis(
                    isVisible: false,
                    minimum: 0,maximum: 2,interval: 0.5, 
                  ),
                  series: <CartesianSeries>[
                    ColumnSeries<ChartColumnData,String>(
                      dataSource: chartData,
                      width: 0.8,
                      color: Colors.amber,
                      xValueMapper: (ChartColumnData data,_)=>data.x, 
                      yValueMapper: (ChartColumnData data,_)=>data.y),
                      ColumnSeries<ChartColumnData,String>(
                      dataSource: chartData,
                      width: 0.8,
                      color: Color.fromARGB(255, 7, 85, 255),
                      xValueMapper: (ChartColumnData data,_)=>data.x, 
                      yValueMapper: (ChartColumnData data,_)=>data.y1)
                  ],
                ),
                Row(children: [
                  Container(
                    width: 27,
                    height: 13,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(20)
                    ),
                  ),
                  SizedBox(width: 10,),
                  Text("Book",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black
                   )),
                   SizedBox(width: 10,),
                   Container(
                    width: 27,
                    height: 13,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 7, 85, 255),
                      borderRadius: BorderRadius.circular(20)
                    ),
                  ),
                  SizedBox(width: 10,),
                  Text("Cookie",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black
                   )),
                ],),
                SizedBox(height: defaultPadding),
                   Text(
                    "This is graph for analytics model",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.blueGrey
                    ),
                   )
            ],
          ),
        ),
    );
  }
}

class ChartColumnData{
  ChartColumnData(this.x,this.y,this.y1);
    final String x;
    final double? y;
    final double? y1;
}
final List<ChartColumnData> chartData = <ChartColumnData>[
    ChartColumnData("Nov", 1.7, 1.7),
    ChartColumnData("Dec", 1.3, 1.3),
    ChartColumnData("Jan", 1, 1),
    ChartColumnData("Feb", 1.5, 1.5),
    ChartColumnData("Mar", 0.5, 0.5),
    ChartColumnData("Apr", 2, 2  )
  ];
