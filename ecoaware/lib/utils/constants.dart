/** Singleton class to accomodate the constant variables
 * used through the application
 */

import 'package:flutter/material.dart';

class Constants{
  static final Constants _instance = Constants._internal();

  Constants._internal();

  factory Constants() {
    return _instance;
  }

  final String appName = "EcoAware";

  // ------ Firebase base URLs--------------
  final String firebaseStorageBaseURL="***"; //add firebase database link
  final String username = '***'; // app developer username
  final String password = '***'; // app developer password
  final String feedbackRecipientEmail = '***';

  final String firebaseStorageCategoryPath="/articles/icons/";
  final String firebaseStorageArticlePath="/articles/images/";


  // ------------------ Colors----------------
  final Color greenColor=Color(0xff007435);
  final Color whiteColor=Color(0xffFFFFFF);
  final Color blueColor=Color(0xff5499C7);
  final Color redColor=Color(0xffff0000);
  final Color greenColorAlpha=Color(0x60007435);


}