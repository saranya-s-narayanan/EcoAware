
/**
 * Class representing settings screen
 */

import 'package:ecoaware/repository/firebase/userupdation_helper.dart';
import 'package:ecoaware/views/widgets/custom_alert.dart';
import 'package:ecoaware/views/widgets/custom_textbox.dart';
import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecoaware/services/notification_service.dart';
import 'package:ecoaware/utils/constants.dart';
import 'widgets/custom_navigation_bar.dart';

void main() {
  runApp(SettingsScreen());
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoAware',
      localizationsDelegates: [
        AppLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: SettingsPage(),
    );
  }
}

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _currentIndex = 2;
  bool _isAlertEnabled = false;
  bool isLoading = false;
  TextEditingController _feddbackMessageController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _loadAlertStatus(); // initialize notification service
  }


  /**
   * Method to share app installation link to other apps
   */
  inviteFriend(bool expanded)
  {
    if(expanded)
    {

      Share.text(
          'EcoAware',
          '${AppLocalizations.of(context)!.invitePrompt} ${AppLocalizations.of(context)!.my_flutter_app}',
          'text/plain');
    }
  }
  /**
   * Method to initialize notification service and toggle widget
   */
  Future<void> _loadAlertStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAlertEnabled = prefs.getBool('alert_enabled') ?? false;
    });
  }

  /**
   * Method to toggle On/OFF for notification togglw button
   */
  Future<void> _toggleAlert(bool newValue) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('alert_enabled', newValue);
    setState(() {
      _isAlertEnabled = newValue;
    });

    if (_isAlertEnabled) {
      // Schedule the monthly alert
      NotificationService().turnOnNotifications();
    } else {
      // Cancel the monthly alert
      NotificationService().cancelNotifications();
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants().whiteColor,

      appBar: AppBar(
        backgroundColor: Constants().whiteColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        leading: Image(
          image: AssetImage('assets/appIcon.png'),
          fit: BoxFit.contain,
        ),
        title: Text(
          Constants().appName,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Constants().greenColor,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              Text(
              AppLocalizations.of(context)!.settings,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              ),
                SizedBox(height: 5.0,),
                buildSettingTile(Icons.info, AppLocalizations.of(context)!.about, Icons.arrow_forward, buildAboutLayout()),
                buildSettingTile(Icons.mail, AppLocalizations.of(context)!.sendFeedback, Icons.arrow_forward, buildFeedbackLayout()),
                buildInviteLayout(Icons.share, AppLocalizations.of(context)!.inviteFriend, Icons.arrow_forward),
                buildReminderLayout(Icons.add_alert, AppLocalizations.of(context)!.monthlyAlerts),
              ],
            ),
          ),
        ),
      ),      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _currentIndex,
        //onTap: _onTabTapped,
      ),
    );
  }

  /**
   *  Method to build each tile of the settings screen
   */

  Widget buildSettingTile(IconData leftIcon, String text, IconData rightIcon, Widget expandableContent) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      margin: EdgeInsets.symmetric( vertical: 5),

      child: ExpansionTile(
        leading: Icon(leftIcon),
        title: Text(text,
          style: TextStyle(
          fontSize: 14,
        )),
        trailing: Icon(rightIcon),
        children: [expandableContent],
      ),
    );
  }

  /**
   *  Method to build about widget of the settings screen
   */
  Widget buildAboutLayout() {
    // Replace this with the layout for the Profile settings
    return Container(
      padding: EdgeInsets.fromLTRB(25.0, 0,25.0, 0),
      child:
      Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0.0, 0,35.0, 0),

            child: Image(
              image: AssetImage('assets/appIcon.png'),
              width: 100,
              height: 100,
            ),
          ),
          Text(
              AppLocalizations.of(context)!.aboutText, textAlign: TextAlign.justify,
            style: TextStyle(
                fontSize: 13,
                height: 1.5
            ),          ),
        ],
      ),
    );
  }

  /**
   *  Method to build feedback widget of the settings screen
   */
  Widget buildFeedbackLayout() {

    // Replace this with the layout for the Security settings
    return Container(
      padding: EdgeInsets.all(16.0),
      child:
      Center(
        child: Column(
          children: [
            CustomTextBox(
              maxLines: 5,// Set the maximum number of lines
              accent: Constants().greenColor,
              label: AppLocalizations.of(context)!.feedbackMessage,
              hint: '',
              errorText: AppLocalizations.of(context)!.errorText,
              controller: _feddbackMessageController,
              textInputAction: TextInputAction.newline,
            inputType: TextInputType.multiline,
            //  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              onSaved: (String value) {
               // _email = value;
              },
            ),
            ElevatedButton( // Submit button
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Constants().greenColor), // Set desired background color
              ),
              child:
                isLoading?
                  SizedBox(
                  width: 24.0,
                  height: 24.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // Set the desired color
                  ),
                )
              // Show loading indicator when isLoading is true
                  : Text(
                  AppLocalizations.of(context)!.send
              ),
              onPressed: () async {

                if(_feddbackMessageController.text.trim().length>5) {
                  setState(() {
                    isLoading =
                    true; // Set isLoading to true when the button is pressed to display loading circle
                  });

                  // Call webservice to send feedback
                  String status = await UserResultUpdationHelper().sendFeedback(
                      textMessage: _feddbackMessageController.text);

                  if (status.contains("success")) {
                    CustomAlerts().displayAlert(
                        AppLocalizations.of(context)!.feedbackSendSuccess,
                        context, "");
                    _feddbackMessageController.text = '';
                    setState(() {
                      isLoading =
                      false; // Set isLoading to false after the processing to hide loading circle
                    });
                  } else { // feedback sending failed
                    CustomAlerts().displayAlert(
                        AppLocalizations.of(context)!.feedbackSendFail, context,
                        "");

                    setState(() {
                      isLoading =
                      false; // Set isLoading to false after the processing to hide loading circle
                    });

                    FocusScope.of(context).unfocus();
                  }
                }else //feedback is empty or not much content
                  CustomAlerts().displayAlert(
                      AppLocalizations.of(context)!.feedbackEmpty, context,
                      "");
              },
            ),

          ],
        ),
      ),
    );
  }

  /**
   *  Method to build invite widget of the settings screen
   */
  Widget buildInviteLayout(IconData leftIcon, String text, IconData rightIcon) {
    // Replace this with the layout for the Notifications settings
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      margin: EdgeInsets.symmetric( vertical: 5),

      child: ExpansionTile(
        leading: Icon(leftIcon),
        title: Text(text,
            style: TextStyle(
              fontSize: 14,
            )),
        trailing: Icon(rightIcon),
        onExpansionChanged: (expanded) => inviteFriend(expanded) ,
      ),
    );
  }

  /**
   *  Method to build reminder widget of the settings screen
   */
  Widget buildReminderLayout(IconData leftIcon, String text) {
    // Replace this with the layout for the Language settings
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      margin: EdgeInsets.symmetric( vertical: 5),

      child: ExpansionTile(
        leading: Icon(leftIcon),
        title: Text(text,
            style: TextStyle(
              fontSize: 14,
            )),
        trailing: Switch(
          value: _isAlertEnabled,
          onChanged: _toggleAlert,
        //  onChanged: _toggleAlert,
        ),
        onExpansionChanged: (expanded) => inviteFriend(expanded) ,
      ),
    );
  }


  @override
  void dispose() {
    _feddbackMessageController.dispose();
    super.dispose();
  }
}
