import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memperio/src/widgets.dart';

class LearnPage extends StatefulWidget {
  const LearnPage({this.id, this.name, this.tag, super.key});
  final String? id;
  final String? name;
  final String? tag;

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  var tagList = [];
  var db = FirebaseFirestore.instance;
  int size = 0;

  @override
  void initState() {
    tagList = widget.tag!.split(',');
    db.collection("learn/${widget.id}/q").get().then((querySnapshot) {
      size = querySnapshot.size;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(widget.name!),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                for (String tag in tagList) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4.0,
                      vertical: 8.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ]
              ],
            ),
            const Header('학습목표를 입력해주세요.'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(child: Text('학습 시간(분)')),
                      Expanded(
                        flex: 4,
                        child: Slider(value: 0, onChanged: (value) {}),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Expanded(child: Text('문제풀이 양')),
                      Expanded(
                        flex: 4,
                        child: Slider(value: 0, onChanged: (value) {}),
                      )
                    ],
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StyledButton(child: const Text('시작하기'), onPressed: () {}),
              ],
            )
          ],
        ),
      ),
    );
  }
}
