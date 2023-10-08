import 'package:flutter/material.dart';
import 'package:memperio/src/learn_category.dart';
import 'package:memperio/app_state.dart' as app_state;

class LearnPage extends StatefulWidget {
  const LearnPage(this.index, {super.key});
  final int index;

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  LearnCategory category = LearnCategory(name: 'tmp', tag: []);

  @override
  void initState() {
    category = app_state.categories[widget.index];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(category.name),
      ),
      body: Row(
        children: [Text(widget.index.toString())],
      ),
    );
  }
}
