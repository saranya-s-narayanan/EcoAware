import 'package:ecoaware/views/main.dart';
import 'package:ecoaware/models/Article.dart';
import 'package:ecoaware/models/QuizQuestion.dart';
import 'package:ecoaware/utils/globals.dart';
import 'package:ecoaware/views/exploredetail_screen.dart';
import 'package:ecoaware/views/explore_screen.dart';
import 'package:ecoaware/views/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  print("*** Testing begin ***");

  print("Testing quiz section....");

  // populate mock data for quiz questions
  List<String> options=[
    "option1",
    "option2",
    "option3",
    "option4"
  ];

  QuizQuestion question=QuizQuestion(
    id: 1,
    title: "title1",
    answer: "answer1",
    tip: "tip1",
  );
  question.setOptions(options);
  Globals().quizQuestions.add(question);

  question=QuizQuestion(
    id: 2,
    title: "title2",
    answer: "answer2",
    tip: "tip2",
  );
  question.setOptions(options);
  Globals().quizQuestions.add(question);

  question=QuizQuestion(
    id: 3,
    title: "title3",
    answer: "answer3",
    tip: "tip3",
  );
  question.setOptions(options);
  Globals().quizQuestions.add(question);

  // --------- Tests----------------------


  group('Quiz section', () {

    testWidgets('Quiz: Widgets rendering test', (WidgetTester tester) async {
     await tester.pumpWidget(MaterialApp(home: QuizScreen()));
      // Verify that the ExplorePage widget is rendered
      expect(find.byType(QuizDetailScreen), findsOneWidget);
      // Verify categories list is not empty
      expect(Globals().quizQuestions,isNotEmpty);
    });

    testWidgets('Quiz: Widgets visibility check', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: ExploreScreen()));
      // Find the ExploreScreen widgets.
      expect(find.text('EcoAware'), findsOneWidget);
      expect(find.text('Enter text'), findsOneWidget);
      expect(find.byType(Radio,skipOffstage: true), findsNothing);
      print("*** Testing end ***");

    });


  });

}
