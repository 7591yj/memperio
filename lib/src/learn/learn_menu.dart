import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memperio/src/learn/learn_category.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'package:memperio/app_state.dart' as app_state;

class LearnMenu extends StatefulWidget {
  const LearnMenu({super.key});

  @override
  State<LearnMenu> createState() => _LearnMenu();
}

class _LearnMenu extends State<LearnMenu> {
  String searchText = '';
  List<LearnCategory> categories = app_state.categories;
  late Set<String> tagsAll = {};
  int? selectedTagIndex;
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
                      initialLabelIndex: selectedTagIndex,
                      doubleTapDisable: true,
                      totalSwitches: tagsAll.length,
                      labels: tagsAll.toList(),
                      onToggle: (index) {
                        try {
                          selectedTagIndex = index!;
                          selectedTag = tagsAll.toList()[index];
                        } catch (e) {
                          selectedTagIndex = null;
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
                  // TODO: Filter categories w/ tags and input
                  if (searchText.isNotEmpty &&
                      !categories[index]
                          .name
                          .toLowerCase()
                          .contains(searchText.toLowerCase())) {
                    return const SizedBox.shrink();
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        )),
                        onPressed: () {
                          context.pushNamed('sub', pathParameters: {
                            'id': index.toString(),
                            'name': categories[index].name,
                            'tag': categories[index].tag.join(','),
                          });
                        },
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
