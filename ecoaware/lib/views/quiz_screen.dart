/**
 * Class representing quiz screen
 */

import 'package:ecoaware/models/QuizQuestion.dart';
import 'package:ecoaware/models/QuizResult.dart';
import 'package:ecoaware/utils/globals.dart';
import 'package:ecoaware/views/home_screen.dart';
import 'package:ecoaware/views/quizresult_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ecoaware/repository/firebase/datasync_helper.dart';
import 'package:ecoaware/repository/firebase/userupdation_helper.dart';
import '../utils/constants.dart';

void main() {
  runApp(QuizScreen());
}

class QuizScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoAware',
      home: QuizDetailScreen(),
      localizationsDelegates: [
        AppLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}

class QuizDetailScreen extends StatefulWidget {
  @override
  _QuizDetailScreenState createState() => _QuizDetailScreenState();
}

class _QuizDetailScreenState extends State<QuizDetailScreen> {
  bool showQuestions = false;
  bool showAnswerPop=false;
  bool isQuestionLoading=false;
  int currentIndex = 0;
  List<QuizQuestion> questions=Globals().quizQuestions;
  List<int?> selectedOptionIndex = List.filled(Globals().quizQuestions.length,null);

  String answerLayoutTitle=" ";
  String answerTip=" ";

  /**
   *   Method to display previous question
   */
  void goToPrevious() {
    setState(() {
      currentIndex = currentIndex > 0 ? currentIndex - 1 : 0;
      if(selectedOptionIndex[currentIndex]!=null)
        checkAnswerAndShowResult();
      else
        showAnswerPop=false;
    });
  }

  /**
   * Method to display next question
   */
  Future<void> goToNext() async {

    // Check if the current question is the final one
    if(currentIndex+1>=questions.length)
      {
        // update quiz result to backend
        String status = await UserResultUpdationHelper().updateQuizResult();
      }
    setState(() {

      if(currentIndex+1<questions.length) { // if there are still questions left
        // update question index
        currentIndex = currentIndex < questions.length - 1
            ? currentIndex + 1
            : currentIndex;
        if (selectedOptionIndex[currentIndex] != null)
          checkAnswerAndShowResult();
        else
          showAnswerPop = false;
      }else{ // if final question
        // Navigate to result screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => QuizResultScreen()),
        );
      }

    });
  }

  /**
   * Method to display questions
   */
  Future<void> displayQuestionLayout() async {
    setState(() {
      isQuestionLoading=true;
    });

    // fetch random 5 quiz questions from Firebase database
    await DataSyncHelper().getQuizQuestions();

    setState(() {
      showQuestions = !showQuestions;
      isQuestionLoading=false;
      questions=Globals().quizQuestions;
    });
    // Initialize reuslt object
    Globals().quizResult=QuizResult(
        id: 1,
        overallScore: 0,
        submittedDate:  DateTime.now().toString());
  }

  /**
   * Method to check if the answer selected by the user
   * for the current question is true or not
   * then, display the answer layout
   */
  void checkAnswerAndShowResult() {
    if(questions[currentIndex].getOptions()[selectedOptionIndex[currentIndex]!].compareTo(questions[currentIndex].getAnswer())==0)
      {
        setState(() {
          answerLayoutTitle= '${AppLocalizations.of(context)!.correctAnswer} \n${AppLocalizations.of(context)!.scoreOne} \n';
          answerTip= questions[currentIndex].getTip();
          showAnswerPop=true;
          Globals().quizResult!.updateScore(Globals().quizResult!.getOverallScore()+1);
        });
      }else {
      setState(() {
        answerLayoutTitle= "${AppLocalizations.of(context)!.incorrectAnswer}"
            " \n${AppLocalizations.of(context)!.scoreZero}"+
            '\n' +"${AppLocalizations.of(context)!.correctanswerIs} \"${questions[currentIndex].getAnswer()}\"";
        answerTip= questions[currentIndex].getTip();
        showAnswerPop=true;

      });
      }

  }

  @override
  void initState() {
    super.initState();


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
          if (!showQuestions)
            Container(
             margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),

             child: Row(
              children: [
                Image.asset(
                  'assets/quizIcon.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.quiz,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),


                    ],
                  ),
                ),
              ],
          ),
           ),

          if (!showQuestions)
            Center(
              child: Column(
                children: [
                  SizedBox(height: 8.0),
                  Text(
                    AppLocalizations.of(context)!.quizText3,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),

                    child: Text(
                      AppLocalizations.of(context)!.quizText2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          height: 1.5),
                    ),
                  ),

                  SizedBox(height: 20),
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Constants().greenColor), // Set desired background color
                      ),
                    child:  isQuestionLoading
                        ? SizedBox(
                      width: 24.0,
                      height: 24.0,
                          child: CircularProgressIndicator(
                         strokeWidth: 2.0,
                         valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // Set the desired color
                      ),
                    ):
                    Text(
                        AppLocalizations.of(context)!.start
                    ),
                    onPressed: displayQuestionLayout,
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),

          //------------ Questions layout -----------------
          if (showQuestions)
            Container(
              margin: EdgeInsets.fromLTRB(16.0,16.0,16.0,0.0),
              child: Column(
                children: [
                  Text(
                    questions[currentIndex].getTitle(),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0.0, 5.0, 20.0, 0.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                              value: 0,
                              groupValue: selectedOptionIndex[currentIndex],
                              onChanged: (value) {
                                setState(() {
                                  selectedOptionIndex[currentIndex] = value;
                                  checkAnswerAndShowResult();
                                });
                              },
                            ),
                            Expanded(
                              child: Text(
                                  questions[currentIndex].getOptions()[0],
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.normal,
                                  )
                              ),
                            ),
                          ],
                        ),
                       Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                              value: 1,
                              groupValue: selectedOptionIndex[currentIndex],
                              onChanged: (value) {
                                setState(() {
                                  selectedOptionIndex[currentIndex] = value;
                                  checkAnswerAndShowResult();
                                });
                              },
                            ),
                            Expanded(
                              child: Text(
                                  questions[currentIndex].getOptions()[1],
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.normal,
                                  )
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                              value: 2,
                              groupValue: selectedOptionIndex[currentIndex],
                              onChanged: (value) {
                                setState(() {
                                  selectedOptionIndex[currentIndex] = value;
                                  checkAnswerAndShowResult();
                                });
                              },
                            ),
                            Expanded(
                              child: Text(
                                  questions[currentIndex].getOptions()[2],
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.normal,
                                  )
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                              value: 3,
                              groupValue: selectedOptionIndex[currentIndex],
                              onChanged: (value) {
                                setState(() {
                                  selectedOptionIndex[currentIndex] = value;
                                  checkAnswerAndShowResult();
                                });
                              },
                            ),
                            Expanded(
                              child: Text(
                                  questions[currentIndex].getOptions()[3],
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.normal,
                                  )
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          //----------- Answer layout ----------------------
          if(showAnswerPop)
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
            decoration: BoxDecoration(
              color: Constants().greenColorAlpha,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              ),
              child: Center(
                child: Container(
                  margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                  child:
                  Column(
                    children: [
                      SizedBox(height: 10.0),
                      Text(
                        answerLayoutTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        ),
                    ),
                      SizedBox(height: 5.0),
                      Text(
                        answerTip,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontStyle: FontStyle.italic
                        ),
                      ),
                      SizedBox(height: 10.0),

                    ],
                  ),
                ),
            ),
          )

        ],
      ),

      //--------------- Navigation layout ------------------------

      bottomNavigationBar:
    Container(
          decoration: BoxDecoration(
          ),
        margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 5.0),
        height: 40.0,
        child: Center(
          child: Row(
            children: [
              if (showQuestions)
                Expanded(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: goToPrevious,
                  ),
                ),
              ),
              if (showQuestions)
                Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '${currentIndex + 1}/${questions.length}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
              if (showQuestions)
                Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: goToNext,
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
