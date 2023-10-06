/**
 * Class representing signup screen
 */

import 'package:ecoaware/views/widgets/custom_alert.dart';
import 'package:ecoaware/views/widgets/custom_textbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:async';
import 'package:ecoaware/repository/firebase/authentication_helper.dart';
import 'package:ecoaware/utils/constants.dart';
import 'signin_screen.dart';


class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoAware',
      home: SignUpPage(),
      theme: ThemeData(
        fontFamily: 'Roboto',
        primaryColor: Constants().greenColor,

      ),

      localizationsDelegates: [
        AppLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final key = GlobalKey<FormState>();

  String _name = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  bool isLoading = false;

  /**
   * Method to validate the entered data
   * and call webservice for registration
   */
  Future<void> register()
  async {
    final state = key.currentState;
    if (state!.validate()) {
      state.save();

      // Check if the email is valid
      if(!AuthenticationHelper().isValidEmail(_email))
      {
        CustomAlerts().displayAlert(AppLocalizations.of(context)!.emailInvalid,context,""); // alert if invalid
      }else {
        // Check if password is valid and matching
        if(_password.trim().length<5)
        {
          CustomAlerts().displayAlert(AppLocalizations.of(context)!.passwordLength, context,""); //alert if invalid

        }else {
          // check if password and confirm password are matching
          if (_confirmPassword.compareTo(_password) != 0) {
            CustomAlerts().displayAlert(
                AppLocalizations.of(context)!.passwordErrorText, context, ""); // alert if not matching
          } else {
            // All conditions met. Proceed to registration
            String status = await AuthenticationHelper().registerUser(
                name: _name,
                email: _email,
                password: _password);

            if (status.contains("success")) // if success, proceed to signin screen
              CustomAlerts().displayAlert(AppLocalizations.of(context)!.signupSuccess,context,"signin");
            else if (status.contains("exist"))
              CustomAlerts().displayAlert(AppLocalizations.of(context)!.signupExists,context,"");
            else
              CustomAlerts().displayAlert(AppLocalizations.of(context)!.signupFail1,context,"");
          }
        }
      }

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Disable resizing to avoid bottom inset
      backgroundColor: Constants().whiteColor,
      // <----------------------------- Top view --------------------------->
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
              MaterialPageRoute(builder: (context) => SignInScreen()),
            );
          },
        )
      ),
      // <----------------------------- Registartion form --------------------------->
      body: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
          padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
          child: Form(
            key: key,
            child: Column(
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
                SizedBox(height: 10.0,),
                Text(
                  AppLocalizations.of(context)!.signup,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0),
                CustomTextBox(
                  accent: Constants().greenColor,
                  inputType: TextInputType.name,
                  label: AppLocalizations.of(context)!.name,
                  hint: '',
                  textInputAction: TextInputAction.next,
                  errorText: AppLocalizations.of(context)!.errorText,
                  onSaved: (String value) {
                    _name = value;
                  },
                ),
                SizedBox(height: 20.0,),
                CustomTextBox(
                  accent: Constants().greenColor,
                  inputType: TextInputType.emailAddress,
                  label: AppLocalizations.of(context)!.email,
                  hint: '',
                  textInputAction: TextInputAction.next,
                  errorText: AppLocalizations.of(context)!.errorText,
                  onSaved: (String value) {
                    _email = value;
                  },
                ),
                SizedBox(height: 20.0,),

                CustomTextBox(
                  obscure: true,
                  accent: Constants().greenColor,
                  label: AppLocalizations.of(context)!.password,
                  hint: '',
                  textInputAction: TextInputAction.next,
                  errorText: AppLocalizations.of(context)!.errorText,
                  onSaved: (String value) {
                    _password = value;
                  },
                ),
                SizedBox(height: 20.0,),

                CustomTextBox(
                  obscure: true,
                  accent: Constants().greenColor,
                  label: AppLocalizations.of(context)!.confirmPassword,
                  hint: '',
                  errorText: AppLocalizations.of(context)!.errorText,
                  onSaved: (String value) {
                    _confirmPassword = value;
                  },
                )
                ,
                SizedBox(height: 20.0,),

                ElevatedButton( // Submit button
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Constants().greenColor), // Set desired background color
                  ),
                    child: isLoading
                        ? SizedBox(
                      width: 24.0,
                      height: 24.0,
                          child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                           valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // Set the desired color
                    ),
                        ) // Show loading indicator when isLoading is true
                        : Text(
                        AppLocalizations.of(context)!.register
                    ),
                  onPressed: () async {
                    setState(() {
                      isLoading = true; // Set isLoading to true when the button is pressed to display loading circle
                    });

                    await register();
                    setState(() {
                      isLoading = false; // Set isLoading to false after the processing to hide loading circle
                    });

                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
