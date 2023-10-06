import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:ecoaware/repository/firebase/datasync_helper.dart';
import 'package:ecoaware/utils/constants.dart';
import 'package:ecoaware/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecoaware/views/main.dart';
import 'package:ecoaware/views/home_screen.dart';

void main() {

  group('LandingScreen', () {

    testWidgets('Navigates to HomeScreen', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LandingScreen()));

      // Simulate a tap on the LandingScreen to navigate to HomeScreen
      await tester.tap(find.byType(EasySplashScreen));

    });


  });
}
