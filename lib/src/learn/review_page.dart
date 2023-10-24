import 'package:flutter/material.dart';
import 'package:memperio/src/widgets.dart';

class ReviewScreen extends StatelessWidget {
  final List<dynamic> content;
  final Duration timeSpent;

  const ReviewScreen(
      {super.key, required this.content, required this.timeSpent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('틀린 문제 다시 보기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [DurationViewer(timeSpent: timeSpent)],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: content.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [Text(content[index].content)],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
