import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:flutter/material.dart';
import 'package:memperio/src/learn/learn_category.dart';
import 'package:memperio/src/widgets.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'package:memperio/app_state.dart' as app_state;
import 'src/authentication.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<LearnCategory> categories = app_state.categories;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MemPerio'),
      ),
      body: ListView(
        children: [
          Consumer<ApplicationState>(
            builder: (context, appState, _) => AuthFunc(
                loggedIn: appState.loggedIn,
                signOut: () {
                  FirebaseAuth.instance.signOut();
                }),
          ),
          Consumer<ApplicationState>(
            builder: (context, appState, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (appState.loggedIn) ...[
                  const StyledContainer(
                    title: '리포트',
                    titleIcon: Icons.workspace_premium_rounded,
                    subButtonEnable: true,
                    route: '/report',
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StyledCircularPercentIndicator(
                          text: '진행도',
                          percent: 0.8,
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        StyledCircularPercentIndicator(
                          text: '목표',
                          percent: 0.7,
                        )
                      ],
                    ),
                  ),
                  StyledContainer(
                    title: '학습',
                    titleIcon: Icons.edit_document,
                    subButtonEnable: true,
                    route: '/learn',
                    content: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (int i = 0; i < categories.length; i++) ...[
                            LearnCategoryButton(
                              name: categories[i].name,
                              tag: categories[i].tag,
                              icon: Icons.abc,
                              id: i,
                            )
                          ],
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  const Text('로그인이 필요합니다.')
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
