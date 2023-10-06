import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:memperio/src/learn_category.dart';

List<LearnCategory> categories = [];

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  var db = FirebaseFirestore.instance;

  Future<void> init() async {
    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
        db.collection("learn").get().then(
          (querySnapshot) {
            for (var docSnapshot in querySnapshot.docs) {
              categories.add(LearnCategory(
                name: docSnapshot.data()['name'],
                tag: docSnapshot.data()['tag'],
              ));
            }
          },
          onError: (e) => print("Error completing: $e"),
        );
        notifyListeners();
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });
  }
}
