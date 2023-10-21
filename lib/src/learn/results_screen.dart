import 'package:flutter/material.dart';
import 'package:memperio/src/learn/review_page.dart';
import 'package:memperio/src/widgets.dart';

class ResultsScreen extends StatefulWidget {
  final String name;
  final String tag;
  final List<dynamic> data;

  const ResultsScreen({
    super.key,
    required this.data,
    required this.name,
    required this.tag,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  var tagList = [];
  int correct = 0;
  List<dynamic> wrong = [];

  void _resultBuilder() {
    for (var result in widget.data) {
      if (result == true) {
        correct++;
      } else {
        wrong.add(result);
      }
    }
  }

  void _showReviewPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ReviewScreen(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _resultBuilder();
    tagList = widget.tag.split(',');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('학습 종료'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(fontSize: 28),
                ),
                TagList(tagList: tagList),
                StyledContainer(
                  title: '결과',
                  titleIcon: Icons.check_circle_outline_rounded,
                  subButtonEnable: false,
                  route: '',
                  content: Column(
                    children: [
                      StyledCircularPercentIndicator(
                        text: '$correct / ${widget.data.length}',
                        percent: correct / widget.data.length,
                      ),
                      const Text(
                        '정답률',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
                ElevatedButton(
                  child: const Text('틀린 문제 다시보기'),
                  onPressed: () {
                    _showReviewPage(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
