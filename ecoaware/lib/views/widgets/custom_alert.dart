import 'package:ecoaware/views/profile_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:ecoaware/repository/firebase/authentication_helper.dart';
import '../../utils/constants.dart';
import '../signin_screen.dart';

class CustomAlerts{
  void displayAlert(String title, BuildContext context, String screen)
  {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(title),
          actions: [
            TextButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                if(screen.trim().length>3)
                {
                  if(screen.contains("signin"))
                  {
                    // Navigate to ExploreScreen
                    Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignInScreen()),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }



  static void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT, // Duration for which the toast is visible
      gravity: ToastGravity.BOTTOM,    // Position of the toast on the screen
      timeInSecForIosWeb: 1,           // Time in seconds for iOS and web
      backgroundColor: Colors.grey[700], // Background color of the toast
      textColor: Colors.white,          // Text color of the toast message
      fontSize: 14.0,                   // Font size of the toast message
    );
  }



  void askConfirmation(String title, BuildContext context, String screen,String actionType)
  {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.confirmation),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              child: Text(AppLocalizations.of(context)!.yes),
              onPressed: () async {
                // Perform logout operation
                Navigator.pop(context); // Close the dialog
                if(actionType.contains("logout")) {
                  AuthenticationHelper().logout();
                  // Navigate to ExploreScreen
                  Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => SignInScreen()),
                  );
                }else if(actionType.contains("delete")){
                  String status = await AuthenticationHelper().deleteAccount();
                  if(status.contains("success"))
                  {
                    //showToast(AppLocalizations.of(context)!.deleteSuccess);

                    await AuthenticationHelper().logout();
                    // Navigate to Signinscreen
                    Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignInScreen()),
                    );
                  }else{
                    showToast(AppLocalizations.of(context)!.deleteFail);

                  }
                }
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.no),
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

}