import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wirenews/utils/constants/colorconstants.dart';

class SignupScreenController with ChangeNotifier {
  bool islogined = false;
  Future registerUser(
      {required String password,
      required String email,
      required BuildContext context}) async {
    try {
      islogined = true;
      notifyListeners();
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        islogined = false;
        notifyListeners();
        return true;
      }
    } on FirebaseAuthException catch (e) {
      log(e.code);
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('The password provided is too weak.'),
          backgroundColor: Colorconstants.primarycolor,
        ));
        islogined = false;
        notifyListeners();
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('The account already exists for that email.'),
          backgroundColor: Colorconstants.primarycolor,
        ));
        islogined = false;
        notifyListeners();
      }
    } catch (e) {
      print(e);
      return false;
    }
    islogined = false;
    notifyListeners();
  }
}
