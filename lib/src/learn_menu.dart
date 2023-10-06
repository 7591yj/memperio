import 'package:flutter/material.dart';
import 'package:memperio/src/widgets.dart';

import 'package:memperio/app_state.dart' as app_state;

class LearnPage extends StatefulWidget {
  const LearnPage({super.key});

  @override
  State<LearnPage> createState() => _LearnPage();
}

class _LearnPage extends State<LearnPage> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('학습'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: TextField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search_rounded),
                ),
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: app_state.categories.length,
                itemBuilder: (BuildContext context, int index) {
                  if (searchText.isNotEmpty &&
                      !app_state.categories[index].name
                          .toLowerCase()
                          .contains(searchText.toLowerCase())) {
                    return const SizedBox.shrink();
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          app_state.categories[index].name,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
