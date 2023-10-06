import 'dart:ui_web';

import 'package:flutter/material.dart';
import 'package:memperio/src/learn_category.dart';
import 'package:memperio/src/widgets.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'package:memperio/app_state.dart' as app_state;

class LearnPage extends StatefulWidget {
  const LearnPage({super.key});

  @override
  State<LearnPage> createState() => _LearnPage();
}

class _LearnPage extends State<LearnPage> {
  String searchText = '';
  List<LearnCategory> categories = app_state.categories;
  late Set<String> tagsAll = {};
  String? selectedTag;

  @override
  void initState() {
    // Get tags from categories and add them to tagsAll
    for (int i = 0; i < categories.length; i++) {
      for (int j = 0; j < categories[i].tag.length; j++) {
        tagsAll.add(categories[i].tag[j]);
      }
    }
    super.initState();
  }

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
            TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search_rounded),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ToggleSwitch(
                      radiusStyle: true,
                      minWidth:
                          MediaQuery.of(context).size.width / tagsAll.length,
                      cornerRadius: 12.0,
                      inactiveBgColor: Colors.deepPurple.shade50,
                      inactiveFgColor: Colors.deepPurple,
                      activeBgColor: const [Colors.deepPurple],
                      initialLabelIndex: null,
                      doubleTapDisable: true,
                      totalSwitches: tagsAll.length,
                      labels: tagsAll.toList(),
                      onToggle: (index) {
                        try {
                          selectedTag = tagsAll.toList()[index!];
                        } catch (e) {
                          selectedTag = null;
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (BuildContext context, int index) {
                  if (searchText.isNotEmpty &&
                      !categories[index]
                          .name
                          .toLowerCase()
                          .contains(searchText.toLowerCase()) &&
                      !categories[index].tag.contains(selectedTag)) {
                    print(categories[index].tag);
                    print(categories[index].tag.contains(selectedTag));
                    print(selectedTag);
                    return const SizedBox.shrink();
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        )),
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            categories[index].name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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
