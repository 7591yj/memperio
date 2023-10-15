import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memperio/src/learn/problem.dart';
import 'package:memperio/src/widgets.dart';

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
  int progress = 0;
  int random = Random().nextInt(4294967295);

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
                        const Text('진행도'),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: progress / howMuch,
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        const SizedBox(height: 30),
                        for (var data in snapshot.data!) ...[
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.shade50,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Header(
                                    data.content,
                                    textStyle: const TextStyle(
                                      fontSize: 24,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                  const TextField(),
                                  const SizedBox(height: 30),
                                  StyledButton(
                                      child: const Text('완료'), onPressed: () {})
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TagContainer(tag: data.from),
                              TagContainer(tag: data.year),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
