/**
 * Class representing Carbon footprint calculator result screen
 */

import 'dart:typed_data';
import 'package:ecoaware/models/CalculatorResult.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
import '../utils/constants.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../utils/globals.dart';
import 'home_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(CalculatorScreen());
}

class CalculatorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoAware',
      home: CalculatorDetailScreen(),
      localizationsDelegates: [
        AppLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}

class CalculatorDetailScreen extends StatefulWidget {
  @override
  _CalculatorDetailScreenState createState() => _CalculatorDetailScreenState();
}

class _CalculatorDetailScreenState extends State<CalculatorDetailScreen> {
  ScreenshotController screenshotController=ScreenshotController();
  List<CalculatorResult> dataPoints = Globals().calculatorResults;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // Method to get vertical points for the line chart
  double _getMaxY(List<CalculatorResult> dataPoints) {
    return dataPoints.map((dataPoint) => dataPoint.getOverallScore()).reduce((a, b) => a > b ? a : b)+30;
  }

  // Method to generate points for the line chart
  List<FlSpot> _generateSpots(List<CalculatorResult> dataPoints) {
    List<FlSpot> spots = [];

    for (int i = 0; i < dataPoints.length; i++) {
      spots.add(FlSpot(i.toDouble(), dataPoints[i].getOverallScore()));
    }

    return spots;
  }

  /** Method to share the calculator
   * result to thid party apps
   */
  shareCalculatorResult () async{
    screenshotController.capture(delay: Duration(milliseconds: 10), pixelRatio: 2.0)
        .then((Uint8List? imageBytes) async {

      if (imageBytes != null) {
        final directory = (await getApplicationDocumentsDirectory()).path;
        File imgFile = File('$directory/calculator.png');

        if (await Permission.storage.request().isGranted) {
          // Either the permission was already granted before or the user just granted it.
          await imgFile.writeAsBytes(imageBytes);
          await Share.file('ecoaware', 'calculator.png', imageBytes, 'image/png',
              text: AppLocalizations.of(context)!.textPrompt2);
        }else{
          print("permission NOT granted!");
        }

      }
    }).catchError((error) {
      print(error);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants().whiteColor,
      appBar: AppBar(
        backgroundColor: Constants().whiteColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press here
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              shareCalculatorResult();
            },
          ),
        ],

      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10.0,0.0,10.0,0.0),
        child: Screenshot(
          controller: screenshotController,
          child: SingleChildScrollView(
            child: Container(
              color: Constants().whiteColor,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('assets/appIcon.png'),
                        width: 30,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 5.0,),
                      Text(
                        Constants().appName,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Constants().greenColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,

                        ),
                      ),
                    ],
                  ),

                  // Custom Curved Rectangle with Pie Chart
                  // Custom Line Chart using fl_chart
                Container(
                  decoration: BoxDecoration(
                    color: Constants().whiteColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Center(
                          child:
                          Container(
                            margin:EdgeInsets.fromLTRB(10.0, 10.0,10.0,0.0),
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Colors.amberAccent.withAlpha(30), // Border color


                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Constants().greenColor.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 3,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.calculator_result_heading,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,

                                  ),
                                ),
                                SizedBox(height: 5.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${Globals().calculatorScore!.getOverallScore().toStringAsFixed(2)} KgCO2e',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Constants().greenColor,

                                      ),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ),

                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                                  Container(
                              width: 180, // Set the desired width for the pie chart
                              height: 180,
                              child: PieChart(
                                PieChartData(
                                  sectionsSpace: 1, // Adjust the space between sections (in degrees)
                                  centerSpaceRadius: 50,
                                  // Adjust the size of the center hole
                                  sections: [
                                    // Add your pie chart sections here
                                    PieChartSectionData(
                                      value: (
                                          (Globals().calculatorScore!.getUtilitiesScore()/
                                              Globals().calculatorScore!.getOverallScore()) *
                                              100), // The value of the first section (in percentage)
                                      color: Colors.blue, // The color of the first section
                                      titleStyle: TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                      title: '${
                                          (
                                              (Globals().calculatorScore!.getUtilitiesScore()/
                                              Globals().calculatorScore!.getOverallScore()) *
                                              100).toStringAsFixed(2)
                                      }%', // The title for the first section (optional)
                                      radius: 25,
                                        titlePositionPercentageOffset: 1.5

                                    ),
                                    PieChartSectionData(
                                      value: (
                                          (Globals().calculatorScore!.getTechScore()/
                                              Globals().calculatorScore!.getOverallScore()) *
                                              100),
                                      color: Colors.green,
                                      titleStyle: TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                      title: '${
                                          (
                                              (Globals().calculatorScore!.getTechScore()/
                                                  Globals().calculatorScore!.getOverallScore()) *
                                                  100).toStringAsFixed(2)
                                      }%',
                                      radius: 25,
                                        titlePositionPercentageOffset: -0.8

                                    ),
                                    PieChartSectionData(
                                      value: (
                                          (Globals().calculatorScore!.getTravelScore()/
                                              Globals().calculatorScore!.getOverallScore()) *
                                              100),
                                      color: Colors.orange,
                                      titleStyle: TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange,
                                      ),
                                      title: '${
                                          (
                                              (Globals().calculatorScore!.getTravelScore()/
                                                  Globals().calculatorScore!.getOverallScore()) *
                                                  100).toStringAsFixed(2)
                                      }%',
                                      radius: 25,
                                        titlePositionPercentageOffset: 1.5



                                    ),
                                    PieChartSectionData(
                                      value: (
                                          (Globals().calculatorScore!.getFoodScore()/
                                              Globals().calculatorScore!.getOverallScore()) *
                                              100),
                                      color: Colors.red,
                                      titleStyle: TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                      title: '${
                                          (
                                              (Globals().calculatorScore!.getFoodScore()/
                                                  Globals().calculatorScore!.getOverallScore()) *
                                                  100).toStringAsFixed(2)
                                      }%',
                                      radius: 25,
                                        titlePositionPercentageOffset: -0.8

                                    ),
                                  ],
                                )
                              ),
                            ),
                                  SizedBox(width: 4.0,),
                                  Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                    Indicator(
                                    color: Colors.blue,
                                    text: AppLocalizations.of(context)!.utilities,
                                    isSquare: true,

                                    ),
                                    SizedBox(
                                    height: 4,
                                    ),
                                    Indicator(
                                    color: Colors.orange,
                                    text: AppLocalizations.of(context)!.travel,
                                    isSquare: true,
                                    ),
                                    SizedBox(
                                    height: 4,
                                    ),
                                    Indicator(
                                    color: Colors.red,
                                    text: AppLocalizations.of(context)!.food,
                                    isSquare: true,
                                    ),
                                    SizedBox(
                                    height: 4,
                                    ),
                                    Indicator(
                                    color: Colors.green,
                                    text: AppLocalizations.of(context)!.tech,
                                    isSquare: true,
                                    ),
                                    SizedBox(
                                    height: 18,
                                    ),
                                    ],
                                    ),

                          ],
                        ),
                      ],
                    ),
                  ),

                ),
                  if(dataPoints.length>1)
                    Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.usageTrend,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10.0,10.0,10.0,0.0),


                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/usageIcon.png',
                              height: 100,
                              fit: BoxFit.contain,
                            ),
                            Container(
                              width: 230, // Set the desired width for the pie chart
                              height: 150,

                             child:
                             LineChart(
                               LineChartData(
                                 gridData: FlGridData(show: false),
                                   titlesData: FlTitlesData(
                                     show: true,
                                     rightTitles: const AxisTitles(
                                       sideTitles: SideTitles(showTitles: false),
                                     ),
                                     topTitles: const AxisTitles(
                                       sideTitles: SideTitles(showTitles: false),
                                     ),
                                     bottomTitles: AxisTitles(
                                       sideTitles: SideTitles(
                                         showTitles: false,
                                         reservedSize: 30,
                                         interval: 1,
                                        // getTitlesWidget: bottomTitleWidgets,
                                       ),
                                     ),
                                     leftTitles: AxisTitles(
                                       sideTitles: SideTitles(
                                         showTitles: false,
                                         interval: 1,
                                         //getTitlesWidget: leftTitleWidgets,
                                         reservedSize: 42,
                                       ),
                                     ),
                                   ),
                                 borderData: FlBorderData(show: true),
                                 minX: 0,
                                 maxX: dataPoints.length.toDouble() - 1,
                                 minY: 0,
                                 maxY: _getMaxY(dataPoints),
                                 lineBarsData: [
                                   LineChartBarData(
                                     spots: _generateSpots(dataPoints),
                                     isCurved: true,
                                     color: Colors.blue,
                                     dotData: FlDotData(show: true),
                                     belowBarData: BarAreaData(show: true),
                                   ),
                                 ],
                                 lineTouchData: LineTouchData(
                                   touchTooltipData: LineTouchTooltipData(
                                     tooltipBgColor: Colors.blue.withOpacity(0.7),
                                     tooltipRoundedRadius: 8,
                                     getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                                       return touchedBarSpots.map((barSpot) {
                                         int index = barSpot.spotIndex.toInt();
                                         DateTime dateTime = DateTime.parse(dataPoints[index].getSubmittedDate());
                                         String monthName = formatDate(dateTime, [M]);
                                         String dateName = formatDate(dateTime, [dd]);
                                         return LineTooltipItem('$dateName $monthName: ${dataPoints[index].getOverallScore()} kGCO2e', TextStyle(color: Colors.white));
                                       }).toList();
                                     },
                                   ),

                                 ),
                               ),
                             ),

                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        'assets/monthIcon.png',
                        width: 100,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}




/*class _Badge extends StatelessWidget {
  const _Badge(
      this.svgAsset, {
        required this.size,
        required this.borderColor,
      });
  final Icon svgAsset;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(

          child:
            svgAsset, // Use the Icons.home constant for the Material Home icon

      ),
    );
  }
}*/

/** class representing the line chart label widgets
 */
class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 12,
    this.textColor,
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}

/*class DataPoint {
  final String dateTimeString;
  final double value;

  DataPoint(this.dateTimeString, this.value);
}*/
