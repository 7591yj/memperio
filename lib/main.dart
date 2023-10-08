import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memperio/src/learn_category.dart';
import 'package:memperio/src/learn_menu.dart';
import 'package:memperio/src/learn_page.dart';
import 'package:memperio/src/report.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'app_state.dart';
import 'package:memperio/app_state.dart' as app_state;
import 'home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: ((context, child) => App()),
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
              // TEMP, FOR TESTING ONLY
              GoRoute(
                  path: '0',
                  builder: (context, state) {
                    return const LearnPage(0);
                  }),
              // TODO: MAKE THIS THING WORK!
              for (int i = 0; i < categories.length; i++) ...[
                GoRoute(
                    path: '$i',
                    builder: (context, state) {
                      return LearnPage(i);
                    })
              ]
            ]),
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
  App({super.key});
  final List<LearnCategory> categories = app_state.categories;

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
