/**
 * Class representing explore article detail viewing screen
 */

import 'package:flutter/material.dart';
import 'package:ecoaware/repository/firebase/storage_helper.dart';
import 'package:ecoaware/models/Article.dart';
import 'package:pinch_zoom_release_unzoom/pinch_zoom_release_unzoom.dart';
import 'package:ecoaware/utils/constants.dart';

void main() {
}

class ExploreDetailScreen extends StatefulWidget {
  late int index; //index of the category in the category list
  List<Article> exploreCategories=[];
  ExploreDetailScreen({required this.index, required this.exploreCategories});

  @override
  _ExploreDetailState createState() => _ExploreDetailState();
}

class _ExploreDetailState extends State<ExploreDetailScreen> {
  List<Article> articles = [];
  List<bool> articlestates = [];
  List<Article> categories = [];

  setArticle(){
    setState(() {
      articles = [];
      articlestates = [];
      if (categories[widget.index].getArticles().length > 0) {
        articles = categories[widget.index].getArticles();
        articlestates = List.generate(
            categories[widget.index].getArticles().length, (
            index) => false);
      }
    });

  }

  @override
  void initState() {
    super.initState();
    categories = widget.exploreCategories ;
    setArticle();
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
            Navigator.of(context).pop(context);
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
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.velocity.pixelsPerSecond.dx > 0) {
          // handle right swipe
            if(widget.index-1>=0)
              widget.index--;
          } else if (details.velocity.pixelsPerSecond.dx < 0) {
            // handle left swipe
            if(widget.index+1>0 && widget.index+1<categories.length)
              widget.index++;
          }
          setArticle();
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    categories[widget.index].getName(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    categories[widget.index].getDescription(),
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 14,
                      height: 2.0
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              ExpansionPanelList.radio(
                elevation: 1,
                expandedHeaderPadding: EdgeInsets.zero,
                animationDuration: Duration(milliseconds: 300),
                children: articles.map<ExpansionPanelRadio>((Article item) {
                  return ExpansionPanelRadio(
                    value: item,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                       // leading: StorageHelper().getArticleImage(item.imgUrl),
                        leading: Image(
                          image: AssetImage('assets/bulletIcon.png'),
                          fit: BoxFit.contain,
                        ),
                        title: Text(item.getName(),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                    body: Column(
                      children: [

                        ListTile(
                          title: Text(item.getDescription(),
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                height: 2.0
                            ),
                          ),
                          subtitle: Text('${item.getID().toString()}'),
                        ),
                        PinchZoomReleaseUnzoomWidget(
                          child: StorageHelper().getArticleImage(item.getImgUrl()),
                          minScale: 0.8,
                          maxScale: 4,
                          resetDuration: const Duration(milliseconds: 200),
                          boundaryMargin: const EdgeInsets.only(bottom: 0),
                          clipBehavior: Clip.none,
                          useOverlay: true,
                          maxOverlayOpacity: 0.5,
                          overlayColor: Colors.black,
                          fingersRequiredToPinch: 2,
                        )
                      ],
                    ),
                    canTapOnHeader: true,
                  );
                }).toList(),
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    articlestates[index] = !isExpanded;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}






