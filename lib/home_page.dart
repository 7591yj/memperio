import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memperio/src/widgets.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'src/authentication.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.workspace_premium_rounded,
                                        color: Colors.deepPurple,
                                        size: 28,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        '리포트',
                                        style: TextStyle(
                                          color: Colors.deepPurple,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  StyledButton(
                                    child: const Text('더보기'),
                                    onPressed: () {
                                      context.push('/report');
                                    },
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Row(
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
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.edit_document,
                                            color: Colors.deepPurple,
                                            size: 28,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            '학습',
                                            style: TextStyle(
                                              color: Colors.deepPurple,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  StyledButton(
                                    child: const Text('더보기'),
                                    onPressed: () {
                                      context.push('/learn');
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  LearnCategoryButton(
                                    text: '화학식 배수',
                                    icon: Icons.abc,
                                    route: '/learn/1',
                                  ),
                                  LearnCategoryButton(
                                    text: '이온화 에너지',
                                    icon: Icons.abc,
                                    route: '/learn/2',
                                  ),
                                  LearnCategoryButton(
                                    text: '분자의 몰수',
                                    icon: Icons.abc,
                                    route: '/learn/3',
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
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
