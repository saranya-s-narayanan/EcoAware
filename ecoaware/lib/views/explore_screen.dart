/**
 * Class representing eplore category listing screen
 */

import 'package:ecoaware/repository/firebase/datasync_helper.dart';
import 'package:ecoaware/models/Article.dart';
import 'package:ecoaware/utils/globals.dart';
import 'package:ecoaware/views/exploredetail_screen.dart';
import 'package:flutter/material.dart';
import 'package:ecoaware/repository/firebase/storage_helper.dart';
import 'package:ecoaware/utils/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'home_screen.dart';

void main() {
  runApp(ExploreScreen());
}

class ExploreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoAware',
      home: ExplorePage(),
      localizationsDelegates: [
        AppLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}

class ExplorePage extends StatefulWidget {

  @override
  _ExplorePageState createState() => _ExplorePageState();

}

class _ExplorePageState extends State<ExplorePage> {
  List<Article> exploreCategories=[];
  TextEditingController _searchController = TextEditingController();

  void updateCategories(String searchText) {
    setState(() {
      exploreCategories=DataSyncHelper().searchAndFetchData(searchText);
    });
  }

  @override
  void initState() {
    super.initState();
    exploreCategories=Globals().categories;
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press here

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
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

      body:SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Image.asset(
                    'assets/exploreIcon.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.explore,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          AppLocalizations.of(context)!.exploreText2,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                children: [
                  SizedBox(width: 200.0),
                  Expanded(
                    child: Container(
                      height: 40.0,
                      child: TextField(
                        controller: _searchController, // Add the controller
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                          hintText: 'Enter text',
                          alignLabelWithHint: true,
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      String searchText = _searchController.text; // Get the entered text
                      // Perform your search operation using the searchText
                      updateCategories(searchText);
                      },
                  ),
                  SizedBox(width: 16.0),
                ],
              ),
            ),

            SizedBox(height: 16.0),

            // --------------- Category Listview--------------
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: exploreCategories.length,
              itemBuilder: (BuildContext context, int index) {
                final item = exploreCategories[index];
                return Container(
                  height: 50,
                  width: 120,
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
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                  child: ListTile(
                    leading: StorageHelper().getCategoryImage(item.getImgUrl()),
                    title: Text(item.getName(),
                        style: TextStyle(
                        color: Constants().greenColor,
                        fontSize: 13,
                  ),),
                    onTap: () {
                      // Handle item tap here
                      if(exploreCategories[index].getArticles()!=null)
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExploreDetailScreen(index: index,exploreCategories: exploreCategories),
                            ),
                          );
                        }

                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),

      /*bottomNavigationBar: CustomNavigationBar(
        currentIndex: _currentIndex,
      ),*/
    );
  }
}


