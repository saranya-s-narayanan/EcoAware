/**
 * Class representing profile updation screen
 */
import 'package:ecoaware/utils/globals.dart';
import 'package:ecoaware/views/widgets/custom_navigation_bar.dart';
import 'package:ecoaware/views/widgets/custom_alert.dart';
import 'package:ecoaware/views/widgets/custom_textbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ecoaware/repository/firebase/authentication_helper.dart';
import '../utils/constants.dart';
import 'signin_screen.dart';


class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoAware',
      home: ProfilePage(),
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
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final key = GlobalKey<FormState>();
  int _currentIndex = 1;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool _isEditing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = Globals().userProfile!=null? Globals().userProfile!.getName():'';
    _emailController.text = Globals().userProfile!=null? Globals().userProfile!.getEmail():'';
    _passwordController.text='';
    _confirmPasswordController.text='';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }


  /**
   * Method to update the new changes to the Firebase database and locally
   */

  Future<void> _saveChanges() async {
    final state = key.currentState;
    if (state!.validate()) {
      state.save();
    if(!AuthenticationHelper().isValidEmail(_emailController.text)) //
    {
      CustomAlerts().displayAlert(AppLocalizations.of(context)!.emailInvalid,context,"");
    }else {
      if (!_passwordController.text.isEmpty) {
        if(_passwordController.text.length<5)
          {
            CustomAlerts().displayAlert(AppLocalizations.of(context)!.passwordLength, context,"");
          }else {
            if (_confirmPasswordController.text.compareTo(_passwordController.text) != 0) {
              CustomAlerts().displayAlert(AppLocalizations.of(context)!.passwordErrorText, context,"");
            } else {
              // update backend with password

               if(_emailController.text.compareTo(Globals().userProfile!.getEmail())!=0) // user changed email address on the textbox
                  {

                // update name, email address to backend without password
                String status = await AuthenticationHelper().updateUserInfo(
                    name: _nameController.text,
                    email: _emailController.text,
                    password: _passwordController.text);

                print("Profile updation status: $status");

                if(status.contains("success"))
                {

                // updation success
                   CustomAlerts().displayAlert(AppLocalizations.of(context)!.updationSuccess,context,"");

                  setState(() {
                    _passwordController.clear();
                    _confirmPasswordController.clear();
                  });

                  // Disable editing mode after saving changes
                  _toggleEditing();
                }
                else if (status.contains("exists")) { // Authentication success, display home screen
                  CustomAlerts().displayAlert(AppLocalizations.of(context)!.emailUpdationExists,context,"");
                }else { // error occurred, display alert
                  CustomAlerts().displayAlert(AppLocalizations.of(context)!.updationFail,context,"");
                }



              }else{ // update only name,password

                // update name to backend with password
                String status = await AuthenticationHelper().updateUserInfo(
                    name: _nameController.text,
                    email: '',
                    password: _passwordController.text);

                print("Profile updation status: $status");

                if(status.contains("success"))
                {
                  // updation success
                   CustomAlerts().displayAlert(AppLocalizations.of(context)!.updationSuccess,context,"");
                  setState(() {
                    _passwordController.clear();
                    _confirmPasswordController.clear();
                  });
                  // Disable editing mode after saving changes
                  _toggleEditing();
                }
              }
            }
        }
      }
      else {

        //update without password
        if(_emailController.text.compareTo(Globals().userProfile!.getEmail())!=0) // user changed email address on the textbox
            {

            // update name, email address to backend without password
            String status = await AuthenticationHelper().updateUserInfo(
                name: _nameController.text,
                email: _emailController.text,
                password: '');

            print("Profile updation status: $status");

            if(status.contains("success"))
            {
              // updation success
             // CustomAlerts().displayAlert(AppLocalizations.of(context)!.updationSuccess,context,"");
              // Disable editing mode after saving changes
              _toggleEditing();
            }
            else if (status.contains("exists")) { // Authentication success, display home screen
              CustomAlerts().displayAlert(AppLocalizations.of(context)!.emailUpdationExists,context,"");
            }else { // error occurred, display alert
              CustomAlerts().displayAlert(AppLocalizations.of(context)!.updationFail,context,"");
            }



        }else{ // update only name

          // update name, email address to backend without password
          String status = await AuthenticationHelper().updateUserInfo(
              name: _nameController.text,
              email: '',
              password: '');

          print("Profile updation status: $status");
          // Disable editing mode after saving changes
          _toggleEditing();
        }

      }
    }




    }

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false, // Disable resizing to avoid bottom inset
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
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                CustomAlerts().askConfirmation(AppLocalizations.of(context)!.confirmLogout,context,"","logout");
                /*showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Confirmation'),
                      content: Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          child: Text(AppLocalizations.of(context)!.yes),
                          onPressed: () {
                            // Perform logout operation
                            Navigator.pop(context); // Close the dialog

                            AuthenticationHelper().logout();
                            // Navigate to ExploreScreen
                            Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => SignInScreen()),
                            );
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
                );*/
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextBox(
                  enabled: _isEditing,
                  accent: Constants().greenColor,
                  inputType: TextInputType.name,
                  label: AppLocalizations.of(context)!.name,
                  hint: '',
                  controller: _nameController,
                  errorText: AppLocalizations.of(context)!.errorText,
                  onSaved: (String value) {
                    //_name = value;
                  },
                ),
                SizedBox(height: 16),
                CustomTextBox(
                  enabled: _isEditing,
                  accent: Constants().greenColor,
                  inputType: TextInputType.emailAddress,
                  label: AppLocalizations.of(context)!.email,
                  hint: '',
                  controller: _emailController,
                  errorText: AppLocalizations.of(context)!.errorText,
                  onSaved: (String value) {
                    //_name = value;
                  },
                ),
                SizedBox(height: 16),
                CustomTextBox(
                  enabled: _isEditing,
                  accent: Constants().greenColor,
                  obscure: true,
                  inputType: TextInputType.visiblePassword,
                  label: AppLocalizations.of(context)!.password,
                  hint: '',
                  controller: _passwordController,
                  errorText: AppLocalizations.of(context)!.errorText,
                  onSaved: (String value) {
                    //_name = value;
                  },
                ),
                SizedBox(height: 16),
                CustomTextBox(
                  enabled: _isEditing,
                  accent: Constants().greenColor,
                  obscure: true,
                  inputType: TextInputType.visiblePassword,
                  label: AppLocalizations.of(context)!.confirmPassword,
                  hint: '',
                  controller: _confirmPasswordController,
                  errorText: AppLocalizations.of(context)!.errorText,
                  onSaved: (String value) {

                  },

                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Constants().greenColor), // Set desired background color
                      ),
                      onPressed: _isEditing ? _saveChanges : _toggleEditing,
                      child: Text(
                          _isEditing ? AppLocalizations.of(context)!.save : AppLocalizations.of(context)!.edit
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0,),
                Center(
                  child: ElevatedButton( // submit button
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
                        AppLocalizations.of(context)!.deleteAccount
                    ),

                    onPressed: () async {

                      //CustomAlerts().askConfirmation(AppLocalizations.of(context)!.confirmDeletion,context,"","delete");
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(AppLocalizations.of(context)!.confirmation),
                            content: Text(AppLocalizations.of(context)!.confirmDeletion),
                            actions: [
                              TextButton(
                                child: Text(AppLocalizations.of(context)!.yes),
                                onPressed: () {
                                  // Perform logout operation
                                  Navigator.pop(context); // Close the dialog

                                  deleteAccount();
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
                    },
                  ),
                ),

              ],
            ),
          ),
        ),

        bottomNavigationBar: CustomNavigationBar(
          currentIndex: _currentIndex,
          //onTap: _onTabTapped,
        ),
      ),
    );
  }

  Future<void> deleteAccount() async {
    setState(() {
      isLoading = true; // Set isLoading to true to display loading circle
    });

    String status = await AuthenticationHelper().deleteAccount();
    if(status.contains("success"))
      {
        CustomAlerts.showToast(AppLocalizations.of(context)!.deleteSuccess);
        setState(() {
          isLoading = false; // Set isLoading to true to display loading circle
        });
        AuthenticationHelper().logout();
        // Navigate to Signinscreen
        Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => SignInScreen()),
        );
      }else{
      CustomAlerts.showToast(AppLocalizations.of(context)!.deleteFail);
      setState(() {
        isLoading = false; // Set isLoading to true to display loading circle
      });
    }
  }


}