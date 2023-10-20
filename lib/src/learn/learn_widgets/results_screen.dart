import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  final List<dynamic> data;

  const ResultsScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    print(data);
    return Scaffold(
      appBar: AppBar(
        title: const Text('학습 완료'),
        automaticallyImplyLeading: false,
        centerTitle: true,
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
