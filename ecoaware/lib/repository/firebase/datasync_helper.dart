/**
 * Class to accomodate methods to synchronise application data from the Firebase database
 */
import 'dart:math';
import 'package:ecoaware/models/Article.dart';
import 'package:ecoaware/models/CalculatorData.dart';
import 'package:ecoaware/models/QuizQuestion.dart';
import 'package:ecoaware/utils/constants.dart';
import 'package:ecoaware/utils/globals.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class DataSyncHelper{

  /** Method to initialise the firebase database setup with the app
   *
   */
  init() async{

    WidgetsFlutterBinding.ensureInitialized();
    /*FirebaseOptions firebaseOptions = FirebaseOptions(
      apiKey: 'AIzaSyDA4jB_BAgS6C8B-IAqB1H10YU0V8JKujU',
      databaseURL: 'https://ecoaware-6b3dc-default-rtdb.europe-west1.firebasedatabase.app',
      appId: '1:858410575628:android:42a9c76c2d8df0429f8b29',
      messagingSenderId: '858410575628',
      projectId: 'ecoaware-6b3dc',
    );*/

    await Firebase.initializeApp(); // initialise firebase

    FirebaseDatabase.instance.setPersistenceEnabled(true); // for offline access

    if (Firebase.apps.isNotEmpty) { // if firbase is successfully initialized
      // Sync data about articles
      await getArticleData();

      // Sync quiz questions
      await getQuizQuestions();

      // Sync Carbon footprint calculator data
      await getCarbonFootprintCalculatorData();
    }

  }

  /** Method to fetch categories and related article details from firebase realtime database and
   * populate the global array list of articles.
   */
  Future<void> getArticleData() async {

    Globals().categories=[];
    DatabaseReference ref = FirebaseDatabase.instance.ref('articleDetails');
    ref.keepSynced(true);

    // Listen for changes to the data.
    ref.orderByChild('parent')
        .once().then((DatabaseEvent databaseEvent) {

      if (databaseEvent.snapshot.value != null && databaseEvent.snapshot.value is List)
      {
        // retrieve data as a list of dynamic type
        List<dynamic> dataList = databaseEvent.snapshot.value as List<dynamic>;

        // fetch details from each attrbute and populate datamodel
        for (var data in dataList)
        {
          // Process each element of the list
          if (data is Map<Object?, Object?>)
          {
            // create article object
            Article article = Article(
                parent: data['reference'] != null ? data['reference'].toString(): '',
                description: data['description'] != null ? data['description'].toString(): '',
                imgUrl: data['img_url'] != null ? data['img_url'].toString(): 'nil',
                name: data['title'] != null ? data['title'].toString(): '',
                id: data['id'] != null ? data['id'] as int:0
            );
            // if the parent is '0', which means it is a main category, so add it to category list
            if(data['parent']==0)
              Globals().categories.add(article);
            else{
              // if the parent is not '0', which means that it is an article. add that article to the arcticle
              //list of respective category object.

              int parent=data['parent'] as int;
              parent--;

              if(parent>-1 && parent<Globals().categories.length) //To tackle outofboundexception
                {
                Globals().categories[parent].addArticle(article);

                }

            }
          }

        }
      }

    });

  }

  /** Method to refine the category list and related article list with respet to the searched keyword
   *
   */
  List<Article> searchAndFetchData(String searchText) {


    List<Article> results=[];

    for(Article article in Globals().categories)
      {

        // if the category decsription contains the searched keyword, append to the result list
        if(article.getDescription().toLowerCase().contains(searchText.toLowerCase()))
          {

            results.add(article);
            continue;
          }else{
          // if any of the articles description in a category contains the searched keyword, append that category to the result list

          for(Article subArticle in article.getArticles())
            {
              if(subArticle.getDescription().toLowerCase().contains(searchText.toLowerCase()))
              {
                results.add(article);
                continue;
              }
            }
        }
      }

    return results;
  }


  /** Method to fetch and populate random 5 quiz questions
   *
   */
  Future<void> getQuizQuestions() async {

    DatabaseReference ref = FirebaseDatabase.instance.ref('quizQuestions');
    ref.keepSynced(true);

    Globals().quizQuestions=[];


    // Get the total number of quiz entries in the database
    DatabaseEvent databaseEvent = (await ref.once()) as DatabaseEvent;
    int totalEntries = (databaseEvent.snapshot.value as List).length;

    // Generate a random starting point for the query
    int randomStartingPoint = Random().nextInt(totalEntries - 5);

    // Listen for changes to the data.
    await ref
        .orderByKey()
        .startAt('$randomStartingPoint')
        .limitToFirst(5)
        .once()
    .then((DatabaseEvent databaseEvent) {

      if (databaseEvent.snapshot.value != null && databaseEvent.snapshot.value is List)
      {
        // retrieve data as a list of dynamic type
        List<dynamic> dataList = databaseEvent.snapshot.value as List<dynamic>;
        // fetch details from each attrbute and populate datamodel
        for (var data in dataList)
        {
          // Process each element of the list
          if (data is Map<Object?, Object?>)
          {
             List<String> options=[
               data['option1']!=null? data['option1'].toString(): '',
               data['option2']!=null? data['option2'].toString(): '',
               data['option3']!=null? data['option3'].toString(): '',
               data['option4']!=null? data['option4'].toString(): ''
             ];

             QuizQuestion question=QuizQuestion(
               id: data['id']!=null? data['id'] as int:0,
               title: data['title']!= null? data['title'].toString():'',
               answer: data['answer']!= null? data['answer'].toString():'',
               tip: data['tip']!= null? data['tip'].toString():'',
             );
             question.setOptions(options);

             Globals().quizQuestions.add(question); //Update quiz questions list

          }

        }
      }

    });

    getLargetsIDfromDB("quizResults");

  }

  Future<int> getLargetsIDfromDB(String collection) async {
    int resultID=0;
    DatabaseReference ref = FirebaseDatabase.instance.ref(collection);
    ref.keepSynced(true);
    await ref
        .orderByChild('id')
        .limitToLast(1)
        .once().then((DatabaseEvent databaseEvent)
        {
          if (databaseEvent.snapshot.value != null) // Email is registered
            {
              if(databaseEvent.snapshot.value is List<Object?>) {
              List<Object?> dataList = databaseEvent.snapshot.value as List<
                  Object?>;

              // Update userProfile with user data frm database
              if (dataList.isNotEmpty) {
                Map<Object?,Object?> data= dataList[dataList.length-1] as Map<Object?,Object?>;

                resultID=int.parse(data['id'] as String);
                resultID++;
              }else{
                resultID=1;
              }
            }else{
              Map<Object?, Object?> dataList = databaseEvent.snapshot.value as Map<Object?, Object?>;

              if (dataList.isNotEmpty) {
                MapEntry<Object?, Object?> firstEntry = dataList.entries.first;
                Object? firstValue = firstEntry.value;
                if (firstValue is Map<Object?, Object?>) {
                  resultID=int.parse(firstValue['id'] as String);
                  resultID++;
                }

                }
            }
          }else{
            resultID=1;
          }
    });

    return resultID;
  }

  Future<void> getCarbonFootprintCalculatorData() async {

    DatabaseReference ref = FirebaseDatabase.instance.ref('calculatorData');
    ref.keepSynced(true);

    Globals().calculatorQuestions=[];

    // Listen for changes to the data.
    ref
        .orderByChild("id")
        .once()
        .then((DatabaseEvent databaseEvent) {

      if (databaseEvent.snapshot.value != null && databaseEvent.snapshot.value is List)
      {
        // retrieve data as a list of dynamic type
        List<dynamic> dataList = databaseEvent.snapshot.value as List<dynamic>;
        // fetch details from each attrbute and populate datamodel
        for (var data in dataList)
        {
          // Process each element of the list
          if (data is Map<Object?, Object?>)
          {


            CalculatorData question=CalculatorData(
              id: data['id']!=null? data['id'] as int:0,
              question: data['question']!= null? data['question'].toString():'',
              emissionFactor: data['emission_factor']!= null? data['emission_factor'] as double:0.0,
              note: data['note']!= null? data['note'].toString():'',
              type: data['type']!= null? data['type'].toString():'',
            );

            Globals().calculatorQuestions.add(question); //Update calculator questions list

          }

        }
      }

    });


  }




}
