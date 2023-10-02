import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memperio/src/widgets.dart';
import 'package:percent_indicator/percent_indicator.dart';
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
          const Divider(
            height: 8,
            thickness: 1,
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
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
                                      })
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircularPercentIndicator(
                                    radius: 80,
                                    lineWidth: 10,
                                    progressColor: Colors.deepPurple,
                                    circularStrokeCap: CircularStrokeCap.round,
                                    center: const Text(
                                      '정확도',
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 40,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircularPercentIndicator(
                                    radius: 80,
                                    lineWidth: 10,
                                    percent: 0.7,
                                    circularStrokeCap: CircularStrokeCap.round,
                                    progressColor: Colors.deepPurple,
                                    center: const Text(
                                      '목표',
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
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
                    child: ElevatedButton(
                      onPressed: () {
                        context.push('/learn');
                      },
                      style: const ButtonStyle(),
                      child: const Column(
                        children: [IconAndDetail(Icons.edit_document, '학습')],
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
