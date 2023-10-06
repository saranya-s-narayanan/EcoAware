/**
 * Launcher class
 * Class representing the splash screen
 */

import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:ecoaware/repository/firebase/authentication_helper.dart';
import 'package:ecoaware/repository/firebase/datasync_helper.dart';
import 'package:ecoaware/utils/constants.dart';
import 'package:ecoaware/views/home_screen.dart';
import 'package:ecoaware/views/signin_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  await DataSyncHelper().init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MaterialApp(
    title: 'EcoAware',
    theme: ThemeData(
      fontFamily: 'Roboto',
    ),
      localizationsDelegates: [
        AppLocalizations.delegate,
      ],
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'), // set default language as English
    home: LandingScreen(),
  ));
}

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {

  @override
  void initState() {
    super.initState();
    DataSyncHelper().init();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

  }


  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Constants().whiteColor,
        body: Center(
            child: EasySplashScreen(
              logo: Image.asset(
                'assets/landingIcon.png',
                fit: BoxFit.contain,
              ),
              title: Text(
                Constants().appName,
                style: TextStyle(
                  fontSize:33,
                  color: Constants().greenColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              //backgroundColor: Colors.grey.shade400,
              showLoader: true,
              loaderColor: Constants().greenColor,
              navigator: callNextScreen(), // call next screen
              durationInSeconds: 3,
            ),

        ),
        bottomNavigationBar:
        Text(
          'Version: 23.08.19 ', // A build number to keep track of the app version
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 9,
            color: Colors.grey,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.italic,
          ),
        ),

      ),
    );
  }

  /** Method to check if the user is previously logged in to the app or not.
   * if already logged in and the credentials are valid, go to home screen
   * Otherwise, go to sign in page
   */
  callNextScreen() async {
    bool? isLogged=false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLogged = prefs.getBool('isLogged');
    if(!(isLogged==true)) { // Not logged in before
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    }
    else { // USer has logged in before
      if(await AuthenticationHelper().emailExists(email:prefs.getString("email").toString())==true) { // check if the user account still present in the db
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }else{
        await AuthenticationHelper().logout();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SignInScreen()),
        );
      }
    }
  }


}
