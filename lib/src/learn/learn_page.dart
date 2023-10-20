import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memperio/src/learn/problem.dart';
import 'package:memperio/src/widgets.dart';

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
  int progress = 0;
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
                        Row(
                          children: [
                            const Text('진행도'),
                            const SizedBox(width: 12),
                            Expanded(
                              child: LinearProgressIndicator(
                                value: progress / howMuch,
                                color: Colors.deepPurple,
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        ProblemContainer(data: snapshot.data!, currentIndex: 0),
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

class ProblemContainer extends StatelessWidget {
  const ProblemContainer({
    super.key,
    required this.data,
    required this.currentIndex,
  });

  final List<Problem> data;
  final int currentIndex;

  void _showResultsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsScreen(data: data),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                  data[currentIndex].content,
                  textStyle: const TextStyle(
                    fontSize: 24,
                    color: Colors.deepPurple,
                  ),
                ),
                TextField(
                  textInputAction: TextInputAction.go,
                  onSubmitted: (value) async {
                    if (currentIndex < data.length - 1) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProblemContainer(
                            data: data,
                            currentIndex: currentIndex + 1,
                          ),
                        ),
                      );
                    } else {
                      _showResultsScreen(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TagContainer(tag: "출제: ${data[currentIndex].from}"),
            TagContainer(tag: "년도: ${data[currentIndex].year}"),
          ],
        ),
      ],
    );
  }
}

class ResultsScreen extends StatelessWidget {
  final List<Problem> data;

  const ResultsScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results Screen'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('End of the list reached. Results:'),
            // Display the final information or results here
          ],
        ),
      ),
    );
  }
}
