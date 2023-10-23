import 'package:flutter/material.dart';

class ReviewScreen extends StatelessWidget {
  final List<dynamic> content;

  const ReviewScreen({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text('Test'),
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
    );
  }
}
