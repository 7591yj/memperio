import 'package:flutter/material.dart';
import 'package:memperio/src/learn/results_screen.dart';
import 'package:memperio/src/widgets.dart';

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
}

class ProblemContainer extends StatefulWidget {
  const ProblemContainer({
    super.key,
    required this.name,
    required this.tag,
    required this.data,
    required this.currentIndex,
    required this.progress,
  });

  final String name;
  final String tag;
  final List<Problem> data;
  final int currentIndex;
  final int progress;

  @override
  State<ProblemContainer> createState() => _ProblemContainerState();
}

class _ProblemContainerState extends State<ProblemContainer> {
  late List<String> inputValues;

  @override
  void initState() {
    super.initState();
    inputValues = List.filled(widget.data.length, '');
  }

  void _showResultsScreen(BuildContext context, String name, String tag) {
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
        result[i] = {widget.data[i]};
      }
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsScreen(data: result, name: name, tag: tag),
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
                          builder: (context) => ProblemContainer(
                            name: widget.name,
                            tag: widget.tag,
                            data: widget.data,
                            currentIndex: widget.currentIndex + 1,
                            progress: widget.progress + 1,
                          ),
                        ),
                      );
                    } else {
                      _showResultsScreen(context, widget.name, widget.tag);
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
