/**
 * Class representing quiz result screen
 */
import 'dart:typed_data';
import 'package:ecoaware/utils/globals.dart';
import 'package:ecoaware/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
import 'package:ecoaware/utils/constants.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const QuizResultScreen());
}

class QuizResultScreen extends StatefulWidget {
  const QuizResultScreen({super.key});

  @override
  State<QuizResultScreen> createState() => _QuizResultState();
}

class _QuizResultState extends State<QuizResultScreen> {
  ScreenshotController screenshotController=ScreenshotController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  /**
   * Method to share the quiz result to
   * other third party apps
   */
   shareQuizResult () async{
    screenshotController.capture(delay: Duration(milliseconds: 10), pixelRatio: 2.0)
        .then((Uint8List? imageBytes) async {
      if (imageBytes != null) {
        final directory = (await getApplicationDocumentsDirectory()).path;
        File imgFile = File('$directory/screenshot.png');

        if (await Permission.storage.request().isGranted) {
          // Either the permission was already granted before or the user just granted it.

          await imgFile.writeAsBytes(imageBytes);

          await Share.file('ecoaware', 'screenshot.png', imageBytes, 'image/png',
              text: AppLocalizations.of(context)!.textPrompt);
        }else{
          print("permission NOT grantd!");
        }
      }
    }).catchError((error) {
      print(error);
    });
   }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
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
                shareQuizResult();
              },
            ),
          ],

        ),
        body: Center(
          child:Column(
            children: [
              Screenshot(
                controller: screenshotController,
                child: Center(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                      Image.asset(
                      'assets/trophyIcon.png',
                      width: 150.0,
                      height: 150.0,
                      ),

                      Text(
                        "${AppLocalizations.of(context)!.congratsQuiz1} "
                            "${Globals().quizResult!.getOverallScore()} "
                            "${AppLocalizations.of(context)!.congratsQuiz2} "
                            "${Globals().quizQuestions.length}.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Constants().greenColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                        SizedBox(height: 5.0),
                        Container(
                          margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Constants().blueColor,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.quizResultTitle,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Constants().greenColor,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.quizResultBp1,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    SizedBox(height: 3.0),
                                    Text(
                                      AppLocalizations.of(context)!.quizResultBp2,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    SizedBox(height: 3.0),
                                    Text(
                                      AppLocalizations.of(context)!.quizResultBp3,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    SizedBox(height: 3.0),
                                    Text(
                                      AppLocalizations.of(context)!.quizResultBp4,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    SizedBox(height: 3.0),
                                    Text(
                                      AppLocalizations.of(context)!.quizResultBp5,
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
                        SizedBox(height: 20.0),



                      ],
                      ),
                  ),
                ),
              ),
            ],
          ),
      ),
      )
    );
  }
}
