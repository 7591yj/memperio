import 'package:flutter/material.dart';
import 'package:memperio/src/learn/results_screen.dart';
import 'package:memperio/src/widgets.dart';

class Question {
  String content;
  String answer;
  String from;
  String year;

  Question({
    this.content = 'temp',
    this.answer = 'temp',
    this.from = 'temp',
    this.year = 'temp',
  });
}

class QuestionContainer extends StatefulWidget {
  const QuestionContainer({
    super.key,
    required this.name,
    required this.tag,
    required this.data,
    required this.currentIndex,
    required this.progress,
    required this.startedAt,
  });

  final String name;
  final String tag;
  final List<Question> data;
  final int currentIndex;
  final int progress;
  final String startedAt;

  @override
  State<QuestionContainer> createState() => _QuestionContainerState();
}

class _QuestionContainerState extends State<QuestionContainer> {
  late List<String> inputValues;
  DateTime startedAt = DateTime.now();

  @override
  void initState() {
    super.initState();
    inputValues = List.filled(widget.data.length, '');
  }

  void _showResultsScreen({
    required BuildContext context,
    required String name,
    required String tag,
    required String startedAt,
    required DateTime endedAt,
  }) {
    var answers = [];
    for (var data in widget.data) {
      answers.add(data.answer);
    }
    // Get list of answers to compare to user inputs
    List<dynamic> result = List.filled(widget.data.length, '');
    for (var i = 0; i < widget.data.length; i++) {
      if (answers[i] == inputValues[i]) {
        result[i] = true;
      } else {
        result[i] = widget.data[i];
      }
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsScreen(
            data: result,
            name: name,
            tag: tag,
            startedAt: DateTime.parse(startedAt),
            endedAt: endedAt),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text('진행도'),
            const SizedBox(width: 12),
            Expanded(
              child: LinearProgressIndicator(
                value: widget.progress / widget.data.length,
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
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
                  widget.data[widget.currentIndex].content,
                  textStyle: const TextStyle(
                    fontSize: 24,
                    color: Colors.deepPurple,
                  ),
                ),
                TextField(
                  onChanged: (value) {
                    inputValues[widget.currentIndex] = value;
                  },
                  textInputAction: TextInputAction.go,
                  onSubmitted: (value) async {
                    if (widget.currentIndex < widget.data.length - 1) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuestionContainer(
                            name: widget.name,
                            tag: widget.tag,
                            data: widget.data,
                            currentIndex: widget.currentIndex + 1,
                            progress: widget.progress + 1,
                            startedAt: widget.startedAt,
                          ),
                        ),
                      );
                    } else {
                      _showResultsScreen(
                          context: context,
                          name: widget.name,
                          tag: widget.tag,
                          startedAt: widget.startedAt,
                          endedAt: DateTime.now());
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
            TagContainer(tag: "출제: ${widget.data[widget.currentIndex].from}"),
            TagContainer(tag: "년도: ${widget.data[widget.currentIndex].year}"),
          ],
        ),
      ],
    );
  }
}
