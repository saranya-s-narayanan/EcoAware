import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en')
  ];

  /// No description provided for @my_flutter_app.
  ///
  /// In en, this message translates to:
  /// **'https://gla-my.sharepoint.com/:u:/g/personal/2827393s_student_gla_ac_uk/EYJmCOMeHvFHp5yQophCp2IB_wP21KRqrqwg_4m8IRsU7Q?e=uCbtGb'**
  String get my_flutter_app;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Your personal guide in combating climate change!'**
  String get tagline;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @quiz.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get quiz;

  /// No description provided for @calculator.
  ///
  /// In en, this message translates to:
  /// **'Carbon footprint calculator'**
  String get calculator;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @publishScore.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get publishScore;

  /// No description provided for @exploreText.
  ///
  /// In en, this message translates to:
  /// **'View information about carbon footprint in various \nsectors and understand its impact'**
  String get exploreText;

  /// No description provided for @exploreText2.
  ///
  /// In en, this message translates to:
  /// **'Select a section to know more about the various factors, which impacts carbon footprint on earth'**
  String get exploreText2;

  /// No description provided for @quizText.
  ///
  /// In en, this message translates to:
  /// **'Test your knowledge in sustainability and share \nthe results'**
  String get quizText;

  /// No description provided for @quizText2.
  ///
  /// In en, this message translates to:
  /// **'Are you ready to test your knowledge and discover how much you know about sustainable living?\nLet\'s get started on this journey of environmental enlightenment!'**
  String get quizText2;

  /// No description provided for @quizText3.
  ///
  /// In en, this message translates to:
  /// **'Welcome to sustainability quiz!\n'**
  String get quizText3;

  /// No description provided for @calculatorText.
  ///
  /// In en, this message translates to:
  /// **'Calculate your contribution to monthly carbon \nfootprint by answering simple questions'**
  String get calculatorText;

  /// No description provided for @quizResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Here are some tips for improving your score:\n'**
  String get quizResultTitle;

  /// No description provided for @quizResultBp1.
  ///
  /// In en, this message translates to:
  /// **'• Choose sustainable transportation'**
  String get quizResultBp1;

  /// No description provided for @quizResultBp2.
  ///
  /// In en, this message translates to:
  /// **'• Eat less meat'**
  String get quizResultBp2;

  /// No description provided for @quizResultBp3.
  ///
  /// In en, this message translates to:
  /// **'• Compost food waste'**
  String get quizResultBp3;

  /// No description provided for @quizResultBp4.
  ///
  /// In en, this message translates to:
  /// **'• Save water as much as possible'**
  String get quizResultBp4;

  /// No description provided for @quizResultBp5.
  ///
  /// In en, this message translates to:
  /// **'• Reduce your energy consumption'**
  String get quizResultBp5;

  /// No description provided for @textPrompt.
  ///
  /// In en, this message translates to:
  /// **'Explore sustainability, test your knowledge, and join the movement for a greener future. 🌱 Install \'EcoAware\' now and embark on a journey towards eco-consciousness. 🌿 '**
  String get textPrompt;

  /// No description provided for @textPrompt2.
  ///
  /// In en, this message translates to:
  /// **'Check out this amazing Footprint Calculator app! 🌱  Install \'EcoAware\' now and embark on a journey towards eco-consciousness. Let\'s take steps together towards a greener future! 🌿 '**
  String get textPrompt2;

  /// No description provided for @congratsQuiz1.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! \nYou scored'**
  String get congratsQuiz1;

  /// No description provided for @congratsQuiz2.
  ///
  /// In en, this message translates to:
  /// **'out of'**
  String get congratsQuiz2;

  /// No description provided for @correctAnswer.
  ///
  /// In en, this message translates to:
  /// **'That\'s correct!'**
  String get correctAnswer;

  /// No description provided for @scoreOne.
  ///
  /// In en, this message translates to:
  /// **'** Score: 1 **'**
  String get scoreOne;

  /// No description provided for @incorrectAnswer.
  ///
  /// In en, this message translates to:
  /// **'That\'s an incorrect answer!'**
  String get incorrectAnswer;

  /// No description provided for @scoreZero.
  ///
  /// In en, this message translates to:
  /// **'** Score: 0 **'**
  String get scoreZero;

  /// No description provided for @correctanswerIs.
  ///
  /// In en, this message translates to:
  /// **'The correct answer is'**
  String get correctanswerIs;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get email;

  /// No description provided for @dob.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get dob;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @errorText.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get errorText;

  /// No description provided for @passwordErrorText.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match. Please check!'**
  String get passwordErrorText;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address!'**
  String get emailInvalid;

  /// No description provided for @passwordLength.
  ///
  /// In en, this message translates to:
  /// **'Password should have atleast 5 characters!'**
  String get passwordLength;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signup;

  /// No description provided for @signin.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signin;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get deleteAccount;

  /// No description provided for @deleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account deletion success!'**
  String get deleteSuccess;

  /// No description provided for @deleteFail.
  ///
  /// In en, this message translates to:
  /// **'Account deletion failed. Please try again later or contact us through the feedback section!'**
  String get deleteFail;

  /// No description provided for @confirmation.
  ///
  /// In en, this message translates to:
  /// **'Confirmation'**
  String get confirmation;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get confirmLogout;

  /// No description provided for @confirmDeletion.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the account?'**
  String get confirmDeletion;

  /// No description provided for @signupSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration success. Please sign in!'**
  String get signupSuccess;

  /// No description provided for @signupFail1.
  ///
  /// In en, this message translates to:
  /// **'Registration failed. Try again!'**
  String get signupFail1;

  /// No description provided for @signupExists.
  ///
  /// In en, this message translates to:
  /// **'Email already registered. Please Sign In!'**
  String get signupExists;

  /// No description provided for @signinMismatch.
  ///
  /// In en, this message translates to:
  /// **'Email and password mismatch. Try again!'**
  String get signinMismatch;

  /// No description provided for @signInFail.
  ///
  /// In en, this message translates to:
  /// **'SignIn failed. Please check credentials!'**
  String get signInFail;

  /// No description provided for @signInNew.
  ///
  /// In en, this message translates to:
  /// **'Email is not registered yet.\nPlease register!'**
  String get signInNew;

  /// No description provided for @emailUpdationExists.
  ///
  /// In en, this message translates to:
  /// **'Email already registered. Please use another email address!'**
  String get emailUpdationExists;

  /// No description provided for @updationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Updation success!'**
  String get updationSuccess;

  /// No description provided for @updationFail.
  ///
  /// In en, this message translates to:
  /// **'Updation failed. Please try again!'**
  String get updationFail;

  /// No description provided for @signupAlternative.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Register here!'**
  String get signupAlternative;

  /// No description provided for @loginAlternative.
  ///
  /// In en, this message translates to:
  /// **'Forgot password? Sign in with code here!'**
  String get loginAlternative;

  /// No description provided for @loginPasscode.
  ///
  /// In en, this message translates to:
  /// **'SignIn with Passcode'**
  String get loginPasscode;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get sendCode;

  /// No description provided for @enterOTP.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP here'**
  String get enterOTP;

  /// No description provided for @emailSent.
  ///
  /// In en, this message translates to:
  /// **'Email with a passcode has been successfully sent!'**
  String get emailSent;

  /// No description provided for @emailFail.
  ///
  /// In en, this message translates to:
  /// **'Unable to send Email. Please check your internet connection!'**
  String get emailFail;

  /// No description provided for @emailExpire.
  ///
  /// In en, this message translates to:
  /// **'The passcode will expire in'**
  String get emailExpire;

  /// No description provided for @emailNew.
  ///
  /// In en, this message translates to:
  /// **'Email not registered!'**
  String get emailNew;

  /// No description provided for @invalidOTP.
  ///
  /// In en, this message translates to:
  /// **'Passcode doesn\'t match. Please try again!'**
  String get invalidOTP;

  /// No description provided for @utilities.
  ///
  /// In en, this message translates to:
  /// **'Utilities'**
  String get utilities;

  /// No description provided for @food.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get food;

  /// No description provided for @tech.
  ///
  /// In en, this message translates to:
  /// **'Tech'**
  String get tech;

  /// No description provided for @travel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get travel;

  /// No description provided for @calculator_result_heading.
  ///
  /// In en, this message translates to:
  /// **'Your overall carbon footprint is'**
  String get calculator_result_heading;

  /// No description provided for @usageTrend.
  ///
  /// In en, this message translates to:
  /// **'The footprint trend in recent months is shown below:'**
  String get usageTrend;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @electricity.
  ///
  /// In en, this message translates to:
  /// **'Electricity'**
  String get electricity;

  /// No description provided for @heating.
  ///
  /// In en, this message translates to:
  /// **'Heating'**
  String get heating;

  /// No description provided for @motorbike.
  ///
  /// In en, this message translates to:
  /// **'Motorbike'**
  String get motorbike;

  /// No description provided for @car.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get car;

  /// No description provided for @chicken.
  ///
  /// In en, this message translates to:
  /// **'Chicken'**
  String get chicken;

  /// No description provided for @beef.
  ///
  /// In en, this message translates to:
  /// **'Beef'**
  String get beef;

  /// No description provided for @smartphone.
  ///
  /// In en, this message translates to:
  /// **'Smartphone'**
  String get smartphone;

  /// No description provided for @laptop.
  ///
  /// In en, this message translates to:
  /// **'Laptop'**
  String get laptop;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @inviteFriend.
  ///
  /// In en, this message translates to:
  /// **'Invite a friend'**
  String get inviteFriend;

  /// No description provided for @monthlyAlerts.
  ///
  /// In en, this message translates to:
  /// **'Monthly reminder'**
  String get monthlyAlerts;

  /// No description provided for @sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get sendFeedback;

  /// No description provided for @aboutText.
  ///
  /// In en, this message translates to:
  /// **'EcoAware aims to provide a tool for individuals to keep track of their carbon footprint and learn more about sustainable practices.\n\nThe information presented in the articles, quiz section, and calculation logic has been referenced from various articles and sources. While efforts have been made to ensure accuracy, these values may not be 100% accurate due to the dynamic nature of environmental factors. However, they will provide users with a general idea of their carbon footprint and encourage them to adopt sustainable habits.\n\nWe hope this app contributes to raising awareness about sustainable living and inspires positive changes in our everyday choices to protect the environment for future generations.\n'**
  String get aboutText;

  /// No description provided for @invitePrompt.
  ///
  /// In en, this message translates to:
  /// **'Explore sustainability, test your knowledge, and join the movement for a greener future. Install \'EcoAware\' now and embark on a journey towards eco-consciousness: '**
  String get invitePrompt;

  /// No description provided for @feedbackMessage.
  ///
  /// In en, this message translates to:
  /// **'Type your message here'**
  String get feedbackMessage;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @feedbackSendFail.
  ///
  /// In en, this message translates to:
  /// **'Unable to send feedback. please try later!'**
  String get feedbackSendFail;

  /// No description provided for @feedbackSendSuccess.
  ///
  /// In en, this message translates to:
  /// **'Thank you for sending feedback!'**
  String get feedbackSendSuccess;

  /// No description provided for @feedbackEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter some message to send!'**
  String get feedbackEmpty;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
