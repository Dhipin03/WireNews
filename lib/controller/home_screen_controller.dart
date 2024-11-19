import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:wirenews/model/home_screen_model.dart';

class HomeScreenController with ChangeNotifier {
  bool issaved = false;
  int selectedindex = 0;
  bool issearckclicked = false;
  bool isloading = false;
  List<Article> articles = [];
  List<Article> articles1 = [];
  final articlelist = FirebaseFirestore.instance.collection('articles');
  void iselected(int index) {
    selectedindex = index;
    notifyListeners();
  }

  void resetindex() {
    selectedindex = 0;
    notifyListeners();
  }

  savearticle(bool value) {
    issaved = value;
    notifyListeners();
  }

  Future<bool> isDuplicate(
      {required String title,
      required String imgurl,
      required String content,
      required String author}) async {
    QuerySnapshot querySnapshot = await articlelist
        .where('title', isEqualTo: title)
        .where('imgurl', isEqualTo: imgurl)
        .where('content', isEqualTo: content)
        .where('author', isEqualTo: author)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  saveArticle({
    required String url,
    required String title,
    required String imgurl,
    required String content,
    required String author,
  }) async {
    final data = {
      'url': url,
      "title": title,
      "imgurl": imgurl,
      "content": content,
      "author": author
    };
    try {
      bool response = await isDuplicate(
          title: title, imgurl: imgurl, content: content, author: author);
      if (response == true) {
        log("Already saved");
      } else {
        articlelist.add(data).then((documentSnapshot) =>
            print("Added Data with ID: ${documentSnapshot.id}"));
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getNewsbyCategory({required String categoryname}) async {
    final url = Uri.parse(
        'https://newsapi.org/v2/top-headlines?category=$categoryname&apiKey=48264279477343ca81a8cbb122807810');
    try {
      isloading = true;
      notifyListeners();
      var response = await http.get(url);
      if (response.statusCode == 200) {
        NewsCategoryresModel newsCategoryresModel =
            newsCategoryresModelFromJson(response.body);
        articles = newsCategoryresModel.articles ?? [];
      }
    } catch (e) {
      print(e);
    }
    isloading = false;
    notifyListeners();
  }

  clicksearch() {
    issearckclicked = !issearckclicked;
    notifyListeners();
  }

  Future<void> searchNews({required String searchitem}) async {
    final url = Uri.parse(
        'https://newsapi.org/v2/everything?q=$searchitem&apiKey=48264279477343ca81a8cbb122807810');
    try {
      isloading = true;
      notifyListeners();
      var response = await http.get(url);
      if (response.statusCode == 200) {
        NewsCategoryresModel newsCategoryresModel =
            newsCategoryresModelFromJson(response.body);
        articles1 = newsCategoryresModel.articles ?? [];
      }
    } catch (e) {
      print(e);
    }
    isloading = false;
    notifyListeners();
  }

  deleteArticles({required var id}) {
    articlelist.doc(id).delete();
  }

  Future<void> shareArticles(var url) async {
    final result = await Share.share(url);

    if (result.status == ShareResultStatus.success) {
      log('Thank you for sharing my website!');
    }
  }
}
