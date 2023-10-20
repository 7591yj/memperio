import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memperio/src/learn/learn_widgets/problem.dart';

class LearnPage extends StatefulWidget {
  const LearnPage({this.name, this.id, this.howMuch, super.key});
  final String? name;
  final String? id;
  final String? howMuch;

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  var db = FirebaseFirestore.instance;
  int howMuch = 1;
  int random = Random().nextInt(4294967295);
  bool submitted = false;

  Future<List<Problem>> getProblemsFromDB() async {
    List<Problem> probList = [];

    void addToProbList(
        List<QueryDocumentSnapshot<Map<String, dynamic>>> querySnapshotDocs) {
      for (var docSnapshot in querySnapshotDocs) {
        var data = docSnapshot.data();
        probList.add(Problem(
          content: data['content'],
          answer: data['answer'],
          from: data['from'],
          year: data['year'],
        ));
      }
    }

    await db
        .collection("learn/${widget.id}/q")
        .where("random", isGreaterThanOrEqualTo: random)
        .orderBy("random")
        .limit(howMuch)
        .get()
        .then((querySnapshot) {
      addToProbList(querySnapshot.docs);
    }).catchError((err) {});
    if (probList.isEmpty) {
      await db
          .collection("learn/${widget.id}/q")
          .where("random", isLessThanOrEqualTo: random)
          .orderBy("random", descending: true)
          .limit(howMuch)
          .get()
          .then((querySnapshot) {
        addToProbList(querySnapshot.docs);
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
      appBar: AppBar(
        title: Text(widget.name!),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: problems,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      children: [
                        ProblemContainer(
                          data: snapshot.data!,
                          currentIndex: 0,
                          progress: 0,
                        ),
                      ],
                    ),
                  ),
                ], // EndFor
              );
            },
          ),
        ],
      ),
    );
  }
}
