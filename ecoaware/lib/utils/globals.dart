/** Class containing the global variables used through the application
 *
 */

import 'package:ecoaware/models/CalculatorResult.dart';
import 'package:ecoaware/models/QuizQuestion.dart';
import '../models/Article.dart';
import '../models/CalculatorData.dart';
import '../models/QuizResult.dart';
import '../models/UserProfile.dart';

class Globals{
  static final Globals _instance = Globals._internal();

  Globals._internal();

  factory Globals() {
    return _instance;
  }

   // ----------- Data model lists----------

  List<Article> categories = [];
  List<QuizQuestion> quizQuestions = [];
  List<CalculatorData> calculatorQuestions = [];
  List<CalculatorResult> calculatorResults= [];

  QuizResult? quizResult=null;
  UserProfile? userProfile=null;
  CalculatorResult? calculatorScore=null;

  double electricityVal=0.0;
  double heatingVal=0.0;
  double motorBikeVal=0.0;
  double nonElectricCarVal=0.0;
  double electricCarVal=0.0;
  double chickenVal=0.0;
  double beefVal=0.0;
  double smartphoneVal=0.0;
  double laptopVal=0.0;



}