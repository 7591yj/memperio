import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memperio/src/learn/learn_menu.dart';
import 'package:memperio/src/learn/learn_menu_sub.dart';
import 'package:memperio/src/learn/learn_page.dart';
import 'package:memperio/src/report.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'app_state.dart';
import 'home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: ((context, child) => const App()),
  ));
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'sign-in',
          builder: (context, state) {
            return SignInScreen(
              actions: [
                ForgotPasswordAction(((context, email) {
                  final uri = Uri(
                    path: '/sign-in/forgot-password',
                    queryParameters: <String, String?>{
                      'email': email,
                    },
                  );
                  context.push(uri.toString());
                })),
                AuthStateChangeAction(((context, state) {
                  final user = switch (state) {
                    SignedIn state => state.user,
                    UserCreated state => state.credential.user,
                    _ => null
                  };
                  if (user == null) {
                    return;
                  }
                  if (state is UserCreated) {
                    user.updateDisplayName(user.email!.split('@')[0]);
                  }
                  if (!user.emailVerified) {
                    user.sendEmailVerification();
                    const snackBar = SnackBar(content: Text('이메일 인증을 진행해주세요.'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  context.go('/');
                })),
              ],
            );
          },
          routes: [
            GoRoute(
              path: 'forgot-password',
              builder: (context, state) {
                final arguments = state.uri.queryParameters;
                return ForgotPasswordScreen(
                  email: arguments['email'],
                  headerMaxExtent: 200,
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: 'profile',
          builder: (context, state) {
            return ProfileScreen(
              providers: const [],
              actions: [
                SignedOutAction((context) {
                  context.pushReplacement('/');
                }),
              ],
            );
          },
        ),
        GoRoute(
          path: 'learn',
          builder: (context, state) {
            return const LearnMenu();
          },
          routes: [
            GoRoute(
                path: 'sub/:id/:name/:tag',
                name: 'sub',
                builder: (context, state) {
                  return LearnMenuSub(
                    id: state.pathParameters['id'],
                    name: state.pathParameters['name'],
                    tag: state.pathParameters['tag'],
                  );
                }),
            GoRoute(
                path: 'page/:name/:tag/:id/:howMuch/:startedAt',
                name: 'learn-page',
                builder: (context, state) {
                  return LearnPage(
                    name: state.pathParameters['name'],
                    id: state.pathParameters['id'],
                    tag: state.pathParameters['tag'],
                    howMuch: state.pathParameters['howMuch'],
                    startedAt: state.pathParameters['startedAt'],
                  );
                }),
          ],
        ),
        GoRoute(
            path: 'report',
            builder: (context, state) {
              return const ReportPage();
            })
      ],
    ),
  ],
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MemPerio',
      theme: ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
