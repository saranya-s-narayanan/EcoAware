
/**
 * Class representing sigin screen
 */

import 'package:ecoaware/repository/firebase/authentication_helper.dart';
import 'package:ecoaware/views/forgot_password.dart';
import 'package:ecoaware/views/home_screen.dart';
import 'package:ecoaware/views/signup_screen.dart';
import 'package:ecoaware/views/widgets/custom_alert.dart';
import 'package:ecoaware/views/widgets/custom_textbox.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:async';
import 'package:ecoaware/utils/constants.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoAware',
      home: SignInPage(),
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
class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final key = GlobalKey<FormState>();

  String _email = '';
  String _password = '';
 bool isLoading = false;

  /** Method to perform authentication with the backend
   *  if success, display home page
   *  Otherwise, show respective alerts to the user
   */

  Future<void> login()
  async {
    final state = key.currentState;
    if (state!.validate()) { // if all the fields are not empty
      state.save();

      if(!AuthenticationHelper().isValidEmail(_email)) // check if the email is valid or not
      {
        CustomAlerts().displayAlert(AppLocalizations.of(context)!.emailInvalid,context,""); // alert invalid
      }else  if(_password.trim().length<5) // Check if password length is less than 5
      {
        CustomAlerts().displayAlert(AppLocalizations.of(context)!.passwordLength, context,""); //alert invalid
      }else { // All conditions met, authenticate with backend

        String status = await AuthenticationHelper().checkLogin(email: _email, password: _password);

        if (status.contains("success")) { // Authentication success, display home screen
          // Navigate to HomeScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }else if(status.contains("new")) // Not a registered email address
          {
            CustomAlerts().displayAlert(AppLocalizations.of(context)!.signInNew,context,"");
          }else if(status.contains("new")) // Not a registered email address
            {
          CustomAlerts().displayAlert(AppLocalizations.of(context)!.signinMismatch,context,"");
        }
        else // Authentication failed, show relevant alert
          CustomAlerts().displayAlert(AppLocalizations.of(context)!.signInFail,context,"");
      }
      setState(() {
        isLoading = false; // Set isLoading to false hide the loading circle
      });

    }else{
      setState(() {
        isLoading = false; // Set isLoading to fale to hide the loading circle
      });
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

      ),
      // <----------------------------- Sign in layout --------------------------->

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
                  AppLocalizations.of(context)!.signin,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0),
                CustomTextBox(
                  accent: Constants().greenColor,
                  inputType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  label: AppLocalizations.of(context)!.email,
                  hint: '',
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
                  errorText: AppLocalizations.of(context)!.errorText,
                  onSaved: (String value) {
                    _password = value;
                  },
                ),
                ElevatedButton( // submit button
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Constants().greenColor),
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
                        AppLocalizations.of(context)!.signin
                    ),

                  onPressed: () async {
                    setState(() {
                      isLoading = true; // Set isLoading to true to display loading circle
                    });

                    await login(); // Call login method


                  },
                ),
                SizedBox(height: 20.0,),
                RichText( // Forgot password textview
                  text: TextSpan(
                    text: AppLocalizations.of(context)!.loginAlternative,
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,

                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Go to Forgot password screen, if tapped
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                        );
                      },
                  ),
                ),
                SizedBox(height: 20.0,),
                RichText( // Signup textview
                  text: TextSpan(
                    text: AppLocalizations.of(context)!.signupAlternative,
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,

                    ),
                    // Go to sign up screen
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Handle tap event here
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpScreen()),
                        );
                      },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }



}
