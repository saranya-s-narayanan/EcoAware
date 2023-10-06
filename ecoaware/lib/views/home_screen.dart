/**
 * Class representing explore article detail viewing screen
 */

import 'package:ecoaware/utils/globals.dart';
import 'package:ecoaware/views/calculator_screen.dart';
import 'package:flutter/material.dart';
import 'package:ecoaware/utils/constants.dart';
import 'package:ecoaware/views/widgets/custom_navigation_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'explore_screen.dart';
import 'quiz_screen.dart';

void main() {
  runApp(HomeScreen());
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoAware',

      localizationsDelegates: [
        AppLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: HomeWidget(),
    );
  }
}


class HomeWidget extends StatelessWidget {
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
          leading: Image(
            image: AssetImage('assets/appIcon.png'),
            fit: BoxFit.contain,
          ),
          title: Text(
            Constants().appName,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Constants().greenColor,
              fontSize: 16,
            ),
          ),
        ),
        body: Column(
        children: [
          Text(
            '${AppLocalizations.of(context)!.welcome} ${Globals().userProfile!.getName()}!',
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
            ),
          ),
          Container(
          margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
          decoration: BoxDecoration(
          border: Border.all(
            color: Constants().greenColor,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
          ),
            child: Material(
               color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Navigate to ExploreScreen
                    Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ExploreScreen()),
                    );
                    },
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                        width: 25,
                        height: 40,
                          child: Image.asset('assets/exploreIcon.png',
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.explore,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                              color: Constants().greenColor,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              ),
                              ),
                            SizedBox(height: 3.0),
                            Text(
                              AppLocalizations.of(context)!.exploreText,
                              style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                              ),
                              ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
            decoration: BoxDecoration(
            border: Border.all(
            color: Constants().greenColor,
            width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  print("Tapped");
                  // Navigate to ExploreScreen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => QuizScreen()),
                  );
                },
                child: Align(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,

                    children: [
                      SizedBox(height: 60.0),
                      SizedBox(width: 10.0),
                      SizedBox(
                        width: 25,
                        height: 30,
                        child: Image.asset('assets/quizIcon.png',fit: BoxFit.fitHeight),
                      ),
                      SizedBox(width: 10.0),
                      Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.quiz,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Constants().greenColor,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 3.0),
                          Text(
                            AppLocalizations.of(context)!.quizText,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Constants().greenColor,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Material(
              color: Colors.transparent,

              child: InkWell(
                onTap: () {
                  // Navigate to ExploreScreen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => CarbonFootprintCalculatorApp()),
                  );
                },
                child: Align(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 60.0),
                      SizedBox(width: 10.0),
                      SizedBox(
                        width: 25,
                        height: 27,
                        child: Image.asset('assets/calculatorIcon.png',fit: BoxFit.fitHeight),
                      ),
                      SizedBox(width: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.calculator,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Constants().greenColor,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 3.0),
                          Text(
                            AppLocalizations.of(context)!.calculatorText,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
        ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: 0,
      ),
    );
  }
}

