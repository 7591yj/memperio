import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:flutter/material.dart';
import 'package:memperio/src/learn_category.dart';
import 'package:memperio/src/widgets.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'package:memperio/app_state.dart' as app_state;
import 'src/authentication.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final List<LearnCategory> categories = app_state.categories;

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
                  const StyledContainer(
                    title: '학습',
                    titleIcon: Icons.edit_document,
                    route: '/learn',
                    content: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          LearnCategoryButton(
                            text: '화학식 배수',
                            icon: Icons.abc,
                            route: '1',
                          ),
                          LearnCategoryButton(
                            text: '이온화 에너지',
                            icon: Icons.abc,
                            route: '2',
                          ),
                          LearnCategoryButton(
                            text: '분자의 몰수',
                            icon: Icons.abc,
                            route: '3',
                          ),
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
