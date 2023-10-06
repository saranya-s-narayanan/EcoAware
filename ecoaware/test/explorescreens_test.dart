import 'package:ecoaware/views/main.dart';
import 'package:ecoaware/models/Article.dart';
import 'package:ecoaware/utils/globals.dart';
import 'package:ecoaware/views/exploredetail_screen.dart';
import 'package:ecoaware/views/explore_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  print("*** Testing begin ***");

  print("Testing explore section....");

  group('Explore section', () {
    // mock categories and articles data
    Article article=Article(
        id:1 ,
        name:'Food' ,
        description:'foods is necessary for all animals to be alive. ' ,
        parent:'0' ,
        imgUrl:'food.PNG' ,);
    Globals().categories.add(article);

    article=Article(
      id:21 ,
      name:'Livestock and Poultry' ,
      description:'Livestock includes domesticated animals such as cattle, sheep, pigs, and horses' ,
      parent:'1' ,
      imgUrl:'food1.PNG' ,);
    Globals().categories[0].addArticle(article);

    // --------- Tests----------------------
    testWidgets('Explore: Rendering', (WidgetTester tester) async {
      print("Testing rendering....");

      await tester.pumpWidget(MaterialApp(home: ExploreScreen()));
      // Verify that the ExplorePage widget is rendered
      expect(find.byType(ExplorePage), findsOneWidget);
      // Verify categories list is not empty
      expect(Globals().categories,isNotEmpty);
    });

    testWidgets('Explore: Visibility check', (WidgetTester tester) async {
      print("Testing widget visibility....");

      await tester.pumpWidget(MaterialApp(home: ExploreScreen()));
      // Find the ExploreScreen widgets.
      expect(find.text('EcoAware'), findsOneWidget);
      expect(find.text('Enter text'), findsOneWidget);
      expect(find.byType(ListTile), findsAtLeastNWidgets(1));
    });
     testWidgets('Explore: Tapping category', (WidgetTester tester) async {
       print("Testing article display related to clicked category....");

       await tester.pumpWidget(MaterialApp(home: ExploreScreen()));
      // Test tapping on an item in the category list.
      final categoryItem = find.byType(ListTile);
      await tester.tap(categoryItem);
      await tester.pumpAndSettle();
      //Verify that the ExploreDetailScreen is shown after tapping an item.
      expect(find.byType(ExploreDetailScreen), findsOneWidget);
    });

    testWidgets('Explore: Test search', (WidgetTester tester) async {
      print("Testing search and filter category....");

      await tester.pumpWidget(MaterialApp(home: ExploreScreen()));
      // Test the search functionality.
      final searchText = 'shoe'; // a word to search for.
      final searchTextField = find.byType(TextField);
      await tester.enterText(searchTextField, searchText);
      await tester.tap(find.byIcon(Icons.search));
      await tester.pump();

      // Verify that the category list is updated based on the search.
      expect(find.text(searchText), findsWidgets);
    });

    testWidgets('Explore Detail: Rendering', (WidgetTester tester) async {
      print("Testing article detail screen rendering....");

      await tester.pumpWidget(MaterialApp(home: ExploreDetailScreen(index: 0, exploreCategories: Globals().categories)));
      // Verify that the ExplorePage widget is rendered
      expect(find.byType(ExploreDetailScreen), findsOneWidget);

      // Verify categories list is not empty
      expect(Globals().categories,isNotEmpty);
    });

    testWidgets('Explore Detail: Visibility check', (WidgetTester tester) async {
      print("Testing article detail screen widget visibility....");

      await tester.pumpWidget(MaterialApp(home: ExploreScreen()));


      // Find the ExploreScreen widgets.
      expect(find.byType(GestureDetector), findsAtLeastNWidgets(1));
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(ExpansionPanelList), findsAtLeastNWidgets(0));
      expect(find.text('Food'), findsOneWidget);


    });

    testWidgets('Explore Detail: Swipe test', (WidgetTester tester) async {
      article=Article(
        id:2 ,
        name:'Water' ,
        description:'Water is inevitable ' ,
        parent:'0' ,
        imgUrl:'water.PNG' ,);
      Globals().categories.add(article);
      print("Testing article detail screen swiping feature....");

      await tester.pumpWidget(MaterialApp(home: ExploreScreen()));


      // Perform a right swipe.
      final gestureEventRight = await tester.startGesture(Offset(500, 300));
      await gestureEventRight.moveBy(Offset(-300, 0));
      await gestureEventRight.up();
      await tester.pump();

      // Verify that the index has decremented and the article has been set.
      expect(find.text('Water'), findsOneWidget);

      // Perform a left swipe.
      final gestureEventLeft = await tester.startGesture(Offset(100, 300));
      await gestureEventLeft.moveBy(Offset(300, 0));
      await gestureEventLeft.up();
      await tester.pump();

      // Verify that the index has incremented and the article has been set.
      expect(find.text('Food'), findsOneWidget);
      print("*** Testing end ***");

    });


  });
}
