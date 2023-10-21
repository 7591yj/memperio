import 'package:flutter/material.dart';
import 'package:memperio/src/widgets.dart';

class ResultsScreen extends StatefulWidget {
  final List<dynamic> data;

  const ResultsScreen({super.key, required this.data});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  int solvedHowMuch = 0;
  int correct = 0;
  List<String> wrong = [];

  void resultBuilder() {
    for (var result in widget.data) {
      if (result == true) {
        correct++;
      } else {
        wrong.add(result as String);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    solvedHowMuch = widget.data.length;
    resultBuilder();
  }

  @override
  Widget build(BuildContext context) {
    print(wrong);
    return Scaffold(
      appBar: AppBar(
        title: const Text('학습 완료'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Header('결과'),
            StyledCircularPercentIndicator(
              text: '$solvedHowMuch / $correct',
              percent: correct / solvedHowMuch,
            ),
            const Header('틀린 문제 다시보기')
          ],
        ),
      ),
    );
  }
}
