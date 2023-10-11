import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LearnPage extends StatefulWidget {
  const LearnPage({this.id, this.howMuch, super.key});
  final String? id;
  final String? howMuch;

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  var db = FirebaseFirestore.instance;
  int howMuch = 1;
  int random = Random().nextInt(4294967295);

  @override
  void initState() {
    howMuch = int.parse(widget.howMuch!);
    // TODO: Fix below getting "No element" err
    db
        .collection("learn/${widget.id}/q")
        .where("random", isGreaterThanOrEqualTo: random)
        .orderBy("random")
        .limit(howMuch)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs != []) {
        print(querySnapshot.docs.first);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(random.toString()),
    );
  }
}
