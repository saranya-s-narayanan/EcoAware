/*
 * class to accomodate authentication related methods using Firebase database
 *
 */
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:ecoaware/models/UserProfile.dart';
import 'package:ecoaware/utils/constants.dart';
import 'package:ecoaware/utils/globals.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:random_string/random_string.dart';

import 'datasync_helper.dart';

class AuthenticationHelper {


  /** Method to register the user with firebase database
   * checks if the entered email is already present on the database
   * - if present, return "exists"
   * - Otherwise, create a row entry with the email address on that, then update the generated 'id' into
   *   the 'id' field of the entered row. return 'success'
   **/
  Future<String> registerUser({required String email, required String password, required String name}) async
  {
    String response="";
    DatabaseReference ref = FirebaseDatabase.instance.ref('userProfiles');
    ref.keepSynced(true);

    // compute 'id' by fetching last id from the database table
    int resultID= await DataSyncHelper().getLargetsIDfromDB("userProfiles");

    // Check if email already registered or not
    await ref.orderByChild('email')
        .equalTo(email)
        .once().then((DatabaseEvent databaseEvent) {
          if (databaseEvent.snapshot.value == null) // Email has not registered yet
          {
            // convert user entered password to sha 256 string
            final bytes = utf8.encode(password); // Convert password string to bytes
            final encodedPassword = sha256.convert(bytes).toString(); //convert bytes to string of sha 256

            // Create a new user
            Map<String, dynamic> user = {
              'name': name,
              'email': email,
              'password': encodedPassword,
              'id': resultID.toString(),
            };

            // Write the user id to the database
            ref.child(user['id']).set(user);

            response= "success";

          } else { // Email already registered
            response="exists";
          }
        });

    print("<-------------------------------------------->");

    return response;
  }

  /** Method to perform login of the user
   * - if the user entered email is not present in the database, return "not exists"
   * - if the email is present, check if the password is matching. if matching, proceed. else, return "not valid"
   * - if the credentials are valid, create a user profile object with the user data from the database
   *, update shared preferences and return "success"
   */

  Future<String> checkLogin({required String email, required String password}) async
  {
    String response="";
    DatabaseReference ref = FirebaseDatabase.instance.ref('userProfiles');
    ref.keepSynced(true);

    // Check if email already registered or not
    await ref.orderByChild('email')
        .equalTo(email)
        .once().then((DatabaseEvent databaseEvent) async {

      if (databaseEvent.snapshot.value != null) // Email is registered
          {

            // Convert entered password to sha 256 string
            final bytes = utf8.encode(password);
            final encodedPassword = sha256.convert(bytes).toString();

            //Fetch the result and check passwords are equal
            Map<Object?, Object?>? dataList;
            if(databaseEvent.snapshot.value is List<Object?>) {
              List<Object?> snapshot = databaseEvent.snapshot.value as List<Object?>;
              if(snapshot.isNotEmpty)
                {
                  dataList=snapshot[snapshot.length-1] as Map<Object?, Object?>?;
                }

            }
            else
              dataList = databaseEvent.snapshot.value as Map<Object?, Object?>;

            if (dataList!.isNotEmpty) {

              Object? firstValue=dataList;
              if(dataList is Map<Object?, Object?>)
                firstValue=dataList.values.first as Map<Object?, Object?>;

              if (firstValue is Map<Object?, Object?>) {
                String savedPassword = firstValue['password'] != null ? firstValue['password'].toString() : '';

                if(savedPassword.compareTo(encodedPassword)==0) // if passwords are matching
                  {

                  // Update user object
                    Globals().userProfile=null;
                    Globals().userProfile=UserProfile(
                        id: firstValue['id'].toString(),
                        name: firstValue['name'].toString(),
                        email: firstValue['email'].toString()
                    );

                    //Update shared preferences
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setString('id', firstValue['id'].toString());
                    await prefs.setString('name',  firstValue['name'].toString());
                    await prefs.setString('email', firstValue['email'].toString());
                    await prefs.setBool('isLogged', true);

                    response='success';

                  }else{
                  response="mismatch";
                }
              }
            }
      } else { // Email not registered
        response="new";
      }
    });
    return response;

  }

  /** Method to send email otp from the application
   *  checks if the email is present in the database using emailExists(email) method
   *  - if present, generate a random 8 digit code, save it in shared preferences and append to the email text string and send to the registered email address
   *      - if success, return "success"
   *      - otherwise, return "fail"
   *      - this passcode will be valid only for 5 minutes or the predefined timer value. after that, it will cleared from shared preference in forgotpassword screen
   *  - if email is not present in the db, return "new"
   */
  Future<String> sendEmailOTP({required String email}) async
  {
    String response = "";

    // check if email is registered or not
    if(await emailExists(email:email)==true) {
      String passcode = randomAlphaNumeric(5);

      String username = Constants().username; // app developer username
      String password = Constants().password; // app developer password

      // Creating the Gmail server
      final smtpServer = gmail(username, password);

      // Create the email message.
      final message = Message()
        ..from = Address(username)
        ..recipients.add(email) //recipent email
        ..subject = 'EcoAware :: Signin passcode   ' //subject of the email
        ..text = 'Dear user, \n\nYour one time passcode : ${passcode}'
            '\nPlease make sure to reset password after successfully signed in to the application.'
            '\n\n\n Thanks,'
            '\n EcoAware team '; //body of the email

      try {
        final sendReport = await send(message, smtpServer);
        print('Message sent: ' +sendReport.toString()); //print if the email is sent
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('passCode', passcode);
        response = "success";
      } on MailerException catch (e) {
        print('Message not sent. \n' + e.toString()); //print if the email is not sent
        response = "fail";
        // e.toString() will show why the email is not sending
      }
    }else
      response="new";

    return response;

  }

  /** Method to perform login with passcode feature
   *  checks if the passcode entered by user matches with the passcode saved in the shared preferences
   *  if matching, sign in granted. return "success"
   *  Otherwise, return "fail"
   */

  Future<String> loginWithPasscode({required String passcode}) async
  {
    String response="";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedPasscode=prefs.getString("passCode").toString();

    if(savedPasscode.compareTo(passcode)==0) // both passcodes are matching
      {
        await prefs.setBool('isLogged', true);
        await prefs.setString('passCode', '');

        response="success";
      }else{ // passcodes not matching
      response="fail";
    }

    return response;

  }

  /** Method to check whether an entered email address already registered on the database.
   * if present, update userProfile object with user data and return true
   * Otherwise, return false
   *
   */

  Future<bool> emailExists({required String email,bool? isUserUpdate}) async {

    bool registered=false;
    DatabaseReference ref = FirebaseDatabase.instance.ref('userProfiles');
    ref.keepSynced(true);

    // Check if email already registered or not
    await ref.orderByChild('email')
        .equalTo(email)
        .once().then((DatabaseEvent databaseEvent) async {

       if (databaseEvent.snapshot.value != null) // Email is registered
          {
         Map<Object?, Object?>? dataList;
         if(databaseEvent.snapshot.value is List<Object?>) {
           List<Object?> snapshot = databaseEvent.snapshot.value as List<Object?>;
           if(snapshot.isNotEmpty)
           {
             dataList=snapshot[snapshot.length-1] as Map<Object?, Object?>?;
           }

         }
         else
           dataList = databaseEvent.snapshot.value as Map<Object?, Object?>;

         if (dataList!.isNotEmpty) {

           Object? firstValue=dataList;
           if(dataList is Map<Object?, Object?>)
             firstValue=dataList.values.first as Map<Object?, Object?>;

          if (firstValue is Map<Object?, Object?>) {
            if(isUserUpdate!=true) { // if user profile update, skip below code

              Globals().userProfile = null;
              Globals().userProfile = UserProfile(
                  id: firstValue['id'].toString(),
                  name: firstValue['name'].toString(),
                  email: firstValue['email'].toString()
              );

              // Update shared preferences of user
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('id', firstValue['id'].toString());
              await prefs.setString('name', firstValue['name'].toString());
              await prefs.setString('email', firstValue['email'].toString());
            }
            registered = true;
          } else {
            // email not present in the db
            registered = false;
          }
        }
      }

      });

    return registered;
  }

  /** Method to check if enatered text is of a valid email format or not
   *  if valid, returns true
   *  Otherwise, returns false
   */

  bool isValidEmail(String email) {
    final pattern = r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$'; // Regular expression to check if email format is valid
    final regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  /** Method to logout the user from the app
   * clears shared preferences to default (null)
   * clears userProfile object to null
   */
  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', '');
    await prefs.setString('name','');
    await prefs.setString('email', '');
    await prefs.setString('passCode', '');
    await prefs.setBool('isLogged', false);

    Globals().userProfile=null;
    Globals().calculatorResults.clear();
    Globals().quizResult=null;

  }

  /** Method to update user info such as name, email and password
   *  cases:
   *    - Name only updation without email and password
   *    - Email only updation without name and password
   *    - password only updation without name and email
   *    - Name and email updation without password
   *    - Name and password updation without email
   *    _ Email and password updation without name
   *    - email, name, and password updation
   */
  Future<String> updateUserInfo({String? name, String? email, String? password}) async {
    String response = "";

    DatabaseReference ref = FirebaseDatabase.instance.ref('userProfiles');
    ref.keepSynced(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(email!.isNotEmpty && password!.isEmpty) // updating only name, email
      {
        // check if email is registered or not
        if(await emailExists(email: email,isUserUpdate: true)==true) {
          response="exists";
        }else{
          // new email address
          await ref.child(Globals().userProfile!.getID()).update({
            'name': name,
            'email': email,
          }).then((_) {

            print ("success");

            // update userProfile object
            Globals().userProfile!.setEmail(email!);
            Globals().userProfile!.setName(name!);


            prefs.setString('name', name);
            prefs.setString('email', email);
            response="success";

          }).catchError((error) {
            print('Error updating data: $error');
            response="error";
          });

        }
      }else if(email!.isEmpty && password!.isEmpty) // updating only name
        {
          await ref.child(Globals().userProfile!.getID()).update({
            'name': name,
          }).then((_) {
            print ("success");

            // update userProfile object
            Globals().userProfile!.setName(name!);


            prefs.setString('name', name);
            response="success";

          }).catchError((error) {
            print('Error updating data: $error');
            response="error";
          });
        }else if(email!.isEmpty && password!.isNotEmpty) // updating only name and password
        {
        final bytes = utf8.encode(password); // Convert password string to bytes
        final encodedPassword = sha256.convert(bytes).toString(); //convert bytes to string of sha 256

          await ref.child(Globals().userProfile!.getID()).update({
            'name': name,
            'password': encodedPassword,
      }).then((_) {
        print ("success");

        // update userProfile object
        Globals().userProfile!.setName(name!);

        prefs.setString('name', name);
        response="success";

      }).catchError((error) {
        print('Error updating data: $error');
        response="error";
      });
    }else if(email!.isNotEmpty && password!.isNotEmpty) // updating only name and password
        {
          if(await emailExists(email: email,isUserUpdate: true)==true) {
            response="exists";
          }else {
            final bytes = utf8.encode(password); // Convert password string to bytes
            final encodedPassword = sha256.convert(bytes)
                .toString(); //convert bytes to string of sha 256


            await ref.child(Globals().userProfile!.getID()).update({
              'name': name,
              'email': email,
              'password': encodedPassword,
            }).then((_) {
              print("success");

              // update userProfile object
              Globals().userProfile!.setName(name!);
              Globals().userProfile!.setEmail(email!);


              prefs.setString('name', name);
              prefs.setString('email', email);
              response = "success";
            }).catchError((error) {
              print('Error updating data: $error');
              response = "error";
            });
          }
    }

    return response;
  }

  /** Method to delete an account permanently from the database
   * Deletion of a user account happens in three steps
   * - Delete the user results from the 'calculatorResults' table
   * - Delete the user results from the 'quizResults' table
   * - Delete the user profile from the 'userProfiles' table   *
   */

  Future<String> deleteAccount({String? name, String? email, String? password}) async {
    String response = "";

    DatabaseReference ref = FirebaseDatabase.instance.ref('userProfiles');
    ref.keepSynced(true);

    try {

      // delete calculator results of the user
      await deleteUserCalculatorResults();

      // delete quiz results of user
      await deleteUserQuizResults();

      // delete user profile
       await  ref.child(Globals().userProfile!.getID()).remove();
      response="success";
    } catch (e) {
      print('Error deleting row: $e');
      response="fail";
    }      

    return response;
  }

  /** Method to delete the calculator result entries of the current user
   *
   */

  deleteUserCalculatorResults() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('calculatorResults');
    ref.keepSynced(true);

    // Listen for changes to the data.
    await ref.orderByChild("userid")
        .equalTo(Globals().userProfile?.getID())
        .once().then((DatabaseEvent databaseEvent) {

      if (databaseEvent.snapshot.value != null)
      {
        if(databaseEvent.snapshot.value is Map<Object?, Object?>) {
          // retrieve data as a list of dynamic type
          Map<Object?, Object?> dataList = databaseEvent.snapshot.value as Map<
              Object?,
              Object?>;
          dataList.forEach((key, value) {

            Map<Object?, Object?> data = value as Map<Object?, Object?>;
            ref.child(data['id'] as String).remove();

          });
        }else if(databaseEvent.snapshot.value is List) {
          // retrieve data as a list of dynamic type
          List<dynamic> dataList = databaseEvent.snapshot.value as List<dynamic>;

          // fetch details from each attrbute and populate datamodel
          for (var data in dataList)
          {
            // Process each element of the list
            if (data is Map<Object?, Object?>)
            {
              // Delete each entry
              ref.child(data['id'] as String).remove();

            }
          }

        }
      }

    });
  }

  /** Method to delete the quiz result entries of the current user
   *
   */
  deleteUserQuizResults() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('quizResults');
    ref.keepSynced(true);

    // Listen for changes to the data.
    await ref.orderByChild("userid")
        .equalTo(Globals().userProfile?.getID())
        .once().then((DatabaseEvent databaseEvent) {

      if (databaseEvent.snapshot.value != null)
      {
        if(databaseEvent.snapshot.value is Map<Object?, Object?>) {
          // retrieve data as a list of dynamic type
          Map<Object?, Object?> dataList = databaseEvent.snapshot.value as Map<
              Object?,
              Object?>;
          //print("Data Map: ${dataList}");
          dataList.forEach((key, value) {

            Map<Object?, Object?> data = value as Map<Object?, Object?>;
            ref.child(data['id'] as String).remove();

          });
        }else if(databaseEvent.snapshot.value is List) {
          // retrieve data as a list of dynamic type
          List<dynamic> dataList = databaseEvent.snapshot.value as List<dynamic>;

          // fetch details from each attrbute and populate datamodel
          for (var data in dataList)
          {
            // Process each element of the list
            if (data is Map<Object?, Object?>)
            {
              // delete each entry
              ref.child(data['id'] as String).remove();

            }
          }

        }
      }

    });
  }

}

 /* Future<int> createUserID(DatabaseReference ref) async {
    int id = -1;
    print("creating userId...");

     ref.once().then((databaseEvent)
         {
           print("databaseEvent: ${databaseEvent.runtimeType}");
           if(databaseEvent.snapshot!=null) {
             print("databaseEvent snapshot: ${databaseEvent.snapshot.runtimeType}");

             if (databaseEvent.snapshot.value != null) {
               print(
                   "databaseEvent.snapshot value: ${databaseEvent.snapshot.value.runtimeType}");
               List<dynamic> dataList = databaseEvent.snapshot.value as List<dynamic>;
               int id=0;
               for (var data in dataList) {
                 // Process each element of the list
                 if (data is Map<Object?, Object?>) {
                    int uId=data['id']!=null? data['id'] as int:0;
                    print("uId: ${uId}");

                 }
               }
             }
           }

         });

    return id;
  }*/
