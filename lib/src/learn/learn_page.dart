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
  // List<Problem> problems = [];

  Future<List<Problem>> getProblemsFromDB() async {
    List<Problem> probList = [];
    await db
        .collection("learn/${widget.id}/q")
        .where("random", isGreaterThanOrEqualTo: random)
        .orderBy("random")
        .limit(howMuch)
        .get()
        .then((querySnapshot) async {
      for (var docSnapshot in querySnapshot.docs) {
        var data = docSnapshot.data();
        probList.add(Problem(
          content: data['content'],
          answer: data['answer'],
          from: data['from'],
          year: data['year'],
        ));
      }
    }).catchError((err) {});
    if (probList.isEmpty) {
      await db
          .collection("learn/${widget.id}/q")
          .where("random", isLessThanOrEqualTo: random)
          .orderBy("random", descending: true)
          .limit(howMuch)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          var data = docSnapshot.data();
          probList.add(Problem(
            content: data['content'],
            answer: data['answer'],
            from: data['from'],
            year: data['year'],
          ));
        }
      }).catchError((err) {});
    }
    return probList;
  }

  @override
  void initState() {
    howMuch = int.parse(widget.howMuch!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<List<Problem>> problems = getProblemsFromDB();
    return Scaffold(
      body: Column(
        children: [
          Text(random.toString()),
          FutureBuilder(
              future: problems,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                snapshot.data![0].printer();
                return Text(snapshot.data![0].content);
              })
        ],
      ),
    );
  }
}

class Problem {
  String content;
  String answer;
  String from;
  String year;

  Problem({
    this.content = 'temp',
    this.answer = 'temp',
    this.from = 'temp',
    this.year = 'temp',
  });

  void printer() {
    print(content + answer + from + year);
  }
}
