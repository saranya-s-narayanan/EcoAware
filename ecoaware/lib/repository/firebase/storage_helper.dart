/** class to accomodate the methods related to fetching images from
 * firebase cloud storage and displaying it as a widget
 */
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';


class StorageHelper{

  /** Method to fetch the image icon of a category from firebase and return as a widget
   *
   */
  Widget getCategoryImage(String imageUrl) {
    if (imageUrl != null && !imageUrl.toString().contains("nil") && Firebase.apps.isNotEmpty) {
      return Image(
        image: FirebaseImage(Constants().firebaseStorageBaseURL+Constants().firebaseStorageCategoryPath+imageUrl,
            shouldCache: true, // The image should be cached (default: True)
            maxSizeBytes: 3000 * 1000, // 3MB max file size (default: 2.5MB)
            cacheRefreshStrategy:
            CacheRefreshStrategy.NEVER // Switch off update checking
        ),
        width: 40,
      );
    } else {
      return Container(
        width: 40,
        height: 40,
        color: Colors.grey,
      );
    }
  }

  /** Method to fetch the image of an article from firebase cloud storage
   * and return as a widget
   */
  Widget getArticleImage(String imageUrl) {
    if (imageUrl != null && !imageUrl.toString().contains("nil") && Firebase.apps.isNotEmpty) {
      return Image(
        image: FirebaseImage(Constants().firebaseStorageBaseURL+Constants().firebaseStorageArticlePath+imageUrl,
            shouldCache: true, // The image should be cached (default: True)
            maxSizeBytes: 3000 * 1000, // 3MB max file size (default: 2.5MB)
            cacheRefreshStrategy:
            CacheRefreshStrategy.NEVER // Switch off update checking
        ),
        width: 300,
      );
    } else {
      return Container(
        width: 40,
        height: 40,
        color: Colors.grey,
      );
    }
  }

}