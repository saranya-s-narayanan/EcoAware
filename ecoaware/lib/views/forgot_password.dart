/**
 * Class representing login with passcode screen
 */

import 'package:ecoaware/repository/firebase/authentication_helper.dart';
import 'package:ecoaware/views/home_screen.dart';
import 'package:ecoaware/views/signin_screen.dart';
import 'package:ecoaware/views/widgets/custom_alert.dart';
import 'package:ecoaware/views/widgets/custom_textbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:ecoaware/utils/constants.dart';


class ForgotPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoAware',
      home: ForgotPasswordPage(),
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
class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final key = GlobalKey<FormState>();

  String _email = '';
  String _passcode = '';
  bool isLoading = false;
  bool sentOTP=false;
  int secondsRemaining = 5 * 60;
  Timer? timer;
  TextEditingController _textEditingController = TextEditingController();

  /**
   * Method to handle email sending and
   * perform respective actions therafter
   */
  Future<void> sendEmail() async {
    final state = key.currentState;
    if (state!.validate()) {
      state.save();

      if(sentOTP==false) { //send email with otp
        String status = await AuthenticationHelper().sendEmailOTP(email: _email);

        if (status.contains("success")) {
          CustomAlerts().displayAlert(AppLocalizations.of(context)!.emailSent,context,"");
          setState(() {
            sentOTP = true; // Set isLoading to true when the button is pressed
          });
          _textEditingController.text='';
          _textEditingController.clear();

          // Start timer
          startTimer();
        }else if(status.contains("new")){ // email entered isn't registered yet
          CustomAlerts().displayAlert(AppLocalizations.of(context)!.emailNew,context,"");
          setState(() {
            sentOTP = false; // Set isLoading to true when the button is pressed
          });
        }
        else { // Email sending failed
          CustomAlerts().displayAlert(AppLocalizations.of(context)!.emailFail,context,"");
          setState(() {
            sentOTP = false; // Set isLoading to true when the button is pressed
          });
        }
      }else{ //verify otp and signin

        stopTimer();
        String status= await AuthenticationHelper().loginWithPasscode( passcode: _passcode);
        if(status.contains("success"))
        {
          // Navigate to Home screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
        else // login failed
          CustomAlerts().displayAlert(AppLocalizations.of(context)!.signInFail,context,"");

      }

    }
    setState(() {
      isLoading = false; // Set isLoading to true when the button is pressed
    });
  }

  /**
   * Method to initialize and start
   * timer for login with passcode
   */
  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      setState(() {
        if (secondsRemaining > 0) {
          secondsRemaining--;
        } else {
          timer.cancel();
        }
      });

      if(secondsRemaining<=0)
      {
        // Timer completed. Cancel login with passcode and go to sign screen
        SharedPreferences prefs =  await SharedPreferences.getInstance();
        prefs.setBool('isLogged', false);
        prefs.setString('passCode','');

        // Navigate to Sign screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInScreen()),
        );
      }
    });
  }

  /**
   * Method to format the timer
   * string to be displayed on the screen
   */
  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String formattedTime =
        '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    return formattedTime;
  }

  /**
   * Method to cancel timer for login with passcode
   */
  Future<void> stopTimer() async {
    timer?.cancel();
  }
  @override
  void dispose() {
    timer?.cancel();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Disable resizing to avoid bottom inset
      backgroundColor: Constants().whiteColor,
      appBar: AppBar(
        backgroundColor: Constants().whiteColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        leading:  IconButton(
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
      body: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
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
                  AppLocalizations.of(context)!.loginPasscode,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,

                  ),
                ),
               (sentOTP==false)?
                Column(
                  children: [
                    SizedBox(height: 20.0),
                    CustomTextBox(
                      controller: _textEditingController,
                      accent: Constants().greenColor,
                      label: AppLocalizations.of(context)!.email,
                      hint: '',
                      errorText: AppLocalizations.of(context)!.errorText,
                      onSaved: (String value) {
                        _email = value;
                      },
                    ),
                    SizedBox(height: 20.0,),

                    ElevatedButton(
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
                            AppLocalizations.of(context)!.sendCode
                        ),
                      onPressed: () async {
                        setState(() {
                          isLoading = true; // Set isLoading to true when the button is pressed
                        });

                        await sendEmail();


                      },
                    ),
                  ],
                ):
                   //---------------------- OTP layout --------------------------
                Column(
                  children: [
                    SizedBox(height: 30.0,),
                    Text(
                      "${AppLocalizations.of(context)!.emailExpire} ${formatTime(secondsRemaining)}",
                      style: TextStyle(
                        color: Constants().redColor,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 20.0,),

                    CustomTextBox(
                      controller: _textEditingController,
                      accent: Constants().greenColor,
                      label: AppLocalizations.of(context)!.enterOTP,
                      hint: '',
                      inputType: TextInputType.text,
                      errorText: AppLocalizations.of(context)!.errorText,
                      onSaved: (String value) {
                        _passcode = value;
                      },
                    ),
                    SizedBox(height: 20.0,),

                    ElevatedButton(
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
                          AppLocalizations.of(context)!.signin
                      ),
                      onPressed: () async {
                        setState(() {
                          isLoading = true; // Set isLoading to true when the button is pressed
                        });

                        await sendEmail();


                      },
                    ),

                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }


}
