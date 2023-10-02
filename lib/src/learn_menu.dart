import 'package:flutter/material.dart';
import 'package:memperio/src/widgets.dart';

class LearnPage extends StatelessWidget {
  const LearnPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('학습'),
      ),
      body: const Row(
        children: [],
      ),
    );
  }
}
