/** class to accomodate the methods related to Firebase database updation
 * result from various user actions
 */

import 'package:ecoaware/models/CalculatorResult.dart';
import 'package:ecoaware/utils/globals.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mailer/mailer.dart' as mailer;
import 'package:mailer/smtp_server/gmail.dart';
import '../../utils/constants.dart';
import 'datasync_helper.dart';

class UserResultUpdationHelper{

  /** Method to update the quiz result of current user to Firebase database
   *
   */

  Future<String> updateQuizResult() async {
    String response = "";

    // Fetch the latest id from database and compute new id
    int resultID= await DataSyncHelper().getLargetsIDfromDB("quizResults");

    DatabaseReference ref = FirebaseDatabase.instance.ref("quizResults");
    ref.keepSynced(true);

    // Create a new data
    Map<String, dynamic> data = {
      'overallScore': Globals().quizResult!.getOverallScore(),
      'submittedDate': Globals().quizResult!.getSubmittedDate(),
      'userid': Globals().userProfile!.getID(),
      'id':resultID.toString(),
    };

    // Write the user id to the database
    await ref.child(data['id']).set(data).then((_) {

      response="success";

    }).catchError((error) {
      print('Error updating data: $error');
      response="error";
    });
    return response;
  }

  /** Method to update calculator result of the current user
   * to Firebase database
   */
  Future<String> updateCalculatorScore() async {
    String response = "";

    // Fetch the latest id from the table and compute new 'id'
    int resultID= await DataSyncHelper().getLargetsIDfromDB("calculatorResults");

    DatabaseReference ref = FirebaseDatabase.instance.ref("calculatorResults");
    ref.keepSynced(true);
    // Create a new data
    Map<String, dynamic> data = {
      'overallScore': Globals().calculatorScore!.getOverallScore().toStringAsFixed(2),
      'submittedDate': Globals().calculatorScore!.getSubmittedDate(),
      'userid': Globals().userProfile!.getID(),
      'id':resultID.toString(),
    };

    // Write the user id to the database
    await ref.child(data['id']).set(data).then((_) {

      response="success";

    }).catchError((error) {
      print('Error updating data: $error');
      response="error";
    });
    return response;
  }

  /** Method to get 6 recent calculator scores of the current user from Firebase
   * database and update local data objects
   */
  Future<void> getRecentCalculatorScores() async {
    Globals().calculatorResults=[];
    DatabaseReference ref = FirebaseDatabase.instance.ref('calculatorResults');
    ref.keepSynced(true);

    // Listen for changes to the data.
   await ref.orderByChild('userid')
        .equalTo(Globals().userProfile?.getID())
        .limitToLast(6)
        .once().then((DatabaseEvent databaseEvent) {

          print("databaseEvent.snapshot.value: ${databaseEvent.snapshot.value}");

      if (databaseEvent.snapshot.value != null)
      {
        if(databaseEvent.snapshot.value is Map<Object?, Object?>) {
          // retrieve data as a list of dynamic type
          Map<Object?, Object?> dataList = databaseEvent.snapshot.value as Map<
              Object?,
              Object?>;
          dataList.forEach((key, value) {

            Map<Object?, Object?> data = value as Map<Object?, Object?>;
            // create result object
            CalculatorResult result = CalculatorResult();
            result.updateSubmittedDate(data['submittedDate'] != null
                ? data['submittedDate'] as String
                : '');
            result.updateOverallScore(
                data['overallScore'] != null ? double.parse(
                    data['overallScore'] as String) : 0.0);
            Globals().calculatorResults.add(result);
          });
        }else if(databaseEvent.snapshot.value is List) {
        // retrieve data as a list of dynamic type
        List<dynamic> dataList = databaseEvent.snapshot.value as List<dynamic>;

        // fetch details from each attribute and populate datamodel
        for (var data in dataList)
        {
          // Process each element of the list
          if (data is Map<Object?, Object?>)
          {
            // create result object
            CalculatorResult result = CalculatorResult();
            result.updateSubmittedDate(data['submittedDate'] != null
                ? data['submittedDate'] as String
                : '');
            result.updateOverallScore(
                data['overallScore'] != null ? double.parse(
                    data['overallScore'] as String) : 0.0);

           // update calculator results list
            Globals().calculatorResults.add(result);

          }
        }

      }
      }

    });


  }

  /** Method to send email otp from the application
   *  checks if the email is present in the database using emailExists(email) method
   *  - if present, generate a random 8 digit code, save it in shared preferences and append to the email text string and send to the registered email address
   *      - if success, return "success"
   *      - otherwise, return "fail"
   *      - this passcode will be valid only for 5 minutes or the predefined timer value. after that, it will cleared from shared preference in forgotpassword screen
   *  - if email is not present in the db, return "new"
   */
  Future<String> sendFeedback({required String textMessage}) async
  {

    String response = "";

    String username = Constants().username; // app developer username
    String password = Constants().password; // app developer password

    // Creating the Gmail server
      final smtpServer = gmail(username, password);

      // Create the email message.
      final message = mailer.Message()
        ..from = mailer.Address(username)
        ..recipients.add(Constants().feedbackRecipientEmail) //recipent email
        ..subject = 'EcoAware :: Feedback from ${Globals().userProfile!.getName()}' //subject of the email
        ..text = 'User id: ${Globals().userProfile!.getID()} \n'
                  'User name: ${Globals().userProfile!.getName()} \n'
                  'User email: ${Globals().userProfile!.getEmail()} \n'
                  'User message: \n'
                  '----------------------------------------------------- \n'
                  '\n${textMessage} \n'
                  '----------------------------------------------------- \n'
                  'Time: ${DateTime.now()} '; //body of the email

      try {
        final sendReport = await mailer.send(message, smtpServer);
        print('Message sent: ' +sendReport.toString()); //print if the email is sent

        response = "success";
      } on mailer.MailerException catch (e) {
        print('Message not sent. \n' + e.toString()); //print if the email is not sent
        response = "fail";
        // e.toString() will show why the email is not sending
      }


    return response;

  }

}
