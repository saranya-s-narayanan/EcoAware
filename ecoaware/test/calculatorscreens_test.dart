import 'package:ecoaware/views/main.dart';
import 'package:ecoaware/models/Article.dart';
import 'package:ecoaware/models/CalculatorData.dart';
import 'package:ecoaware/models/QuizQuestion.dart';
import 'package:ecoaware/utils/globals.dart';
import 'package:ecoaware/views/calculatorresult_screen.dart';
import 'package:ecoaware/views/exploredetail_screen.dart';
import 'package:ecoaware/views/explore_screen.dart';
import 'package:ecoaware/views/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  print("*** Testing begin ***");

  print("Testing calculator section....");

  // Add mock calculator questions
  CalculatorData question=CalculatorData(
    id: 1,
    question: "question 1",
    emissionFactor: 1.0,
    note: "note 1",
    type: "utilities",
  );

  Globals().calculatorQuestions.add(question); //Update calculator questions list

  question=CalculatorData(
    id: 2,
    question: "question 2",
    emissionFactor: 1.0,
    note: "note 2",
    type: "Travel",
  );

  Globals().calculatorQuestions.add(question);

   question=CalculatorData(
    id: 3,
    question: "question 3",
    emissionFactor: 1.0,
    note: "note 3",
    type: "food",
  );

  Globals().calculatorQuestions.add(question);

   question=CalculatorData(
    id: 4,
    question: "question 4",
    emissionFactor: 1.0,
    note: "note 4",
    type: "tech",
  );

  Globals().calculatorQuestions.add(question);
  // --------- Tests----------------------

  group('Calculator section', () {

    testWidgets('Calculator: Widgets rendering test', (WidgetTester tester) async {
     await tester.pumpWidget(MaterialApp(home: CalculatorScreen()));
      // Verify that the ExplorePage widget is rendered
      expect(find.byType(CalculatorDetailScreen), findsOneWidget);
      // Verify categories list is not empty
      expect(Globals().calculatorQuestions,isNotEmpty);
    });

    testWidgets('Calculator: Widgets visibility check', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: CalculatorScreen()));
      // Find the ExploreScreen widgets.
      expect(find.text('EcoAware'), findsOneWidget);
      expect(find.text('Enter text'), findsOneWidget);

      print("*** Testing end ***");

    });


  });
}
