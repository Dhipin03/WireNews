import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:wirenews/model/home_screen_model.dart';
import 'package:wirenews/service/api_service.dart';

class HomeScreenController with ChangeNotifier {
  final ApiService apiService = ApiService();
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
      {required String title, required String url}) async {
    try {
      if (url.isNotEmpty) {
        QuerySnapshot querySnapshot =
            await articlelist.where('url', isEqualTo: url).get();
        if (querySnapshot.docs.isNotEmpty) return true;
      }
      if (title.isNotEmpty) {
        QuerySnapshot querySnapshot =
            await articlelist.where('title', isEqualTo: title).get();
        if (querySnapshot.docs.isNotEmpty) return true;
      }
      return false;
    } catch (e) {
      log("Error checking duplicate: $e");
      return false;
    }
  }

  Future<bool> checkIfSaved(
      {required String title, required String url}) async {
    return await isDuplicate(title: title, url: url);
  }

  Future<void> removeSavedArticle({
    required String url,
    required String title,
  }) async {
    try {
      QuerySnapshot querySnapshot;
      if (url.isNotEmpty) {
        querySnapshot = await articlelist.where('url', isEqualTo: url).get();
      } else {
        querySnapshot =
            await articlelist.where('title', isEqualTo: title).get();
      }
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      issaved = false;
      notifyListeners();
    } catch (e) {
      log("Error removing article: $e");
    }
  }

  Future<String?> saveArticle({
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
      "author": author,
      "createdAt": FieldValue.serverTimestamp(),
    };
    try {
      bool duplicate = await isDuplicate(title: title, url: url);
      if (duplicate) {
        log("Already saved");
        issaved = true;
        notifyListeners();
        return null;
      } else {
        DocumentReference docRef = await articlelist.add(data);
        log("Added Data with ID: ${docRef.id}");
        issaved = true;
        notifyListeners();
        return null; // Success
      }
    } catch (e) {
      log("Error saving article: $e");
      return e.toString();
    }
  }

  Future<void> getNewsbyCategory({required String categoryname}) async {
    try {
      isloading = true;
      notifyListeners();
      var response = await apiService.getnews(categoryname);
      articles = response.articles ?? [];
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
    try {
      isloading = true;
      notifyListeners();
      var response = await apiService.searchnews(searchitem);
      articles1 = response.articles ?? [];
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
