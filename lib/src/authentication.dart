import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'widgets.dart';

class AuthFunc extends StatelessWidget {
  const AuthFunc({
    super.key,
    required this.loggedIn,
    required this.signOut,
  });

  final bool loggedIn;
  final void Function() signOut;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Visibility(
            visible: loggedIn,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: UserAvatar(
                auth: FirebaseAuth.instance,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: loggedIn,
                child: EditableUserDisplayName(auth: FirebaseAuth.instance),
              ),
              Visibility(
                visible: loggedIn,
                child: const DDayViewer(),
              )
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: StyledButton(
                  onPressed: () {
                    !loggedIn ? context.push('/sign-in') : signOut();
                  },
                  child: !loggedIn ? const Text('로그인') : const Text('로그아웃'),
                ),
              ),
              Visibility(
                visible: loggedIn,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  child: StyledButton(
                    onPressed: () {
                      context.push('/profile');
                    },
                    child: const Text('프로필'),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class DDayViewer extends StatefulWidget {
  const DDayViewer({super.key});

  @override
  State<DDayViewer> createState() => _DDayViewer();
}

class _DDayViewer extends State<DDayViewer> {
  bool dateSelected = false;
  DateTime selectedDate = DateTime.now();
  DateTime dueDate = DateTime.now().add(const Duration(days: 1));
  int differenceFromToday = 1;
  int differenceFromSelectedDate = 1;

  int differenceCalcFromToday() {
    return dueDate.difference(DateTime.now()).inDays + 1;
  }

  int differenceCalcFromSelectedDate() {
    return dueDate.difference(selectedDate).inDays + 1;
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          if (dateSelected) ...[
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('중간고사까지'),
                    Text('D-$differenceFromToday'),
                  ],
                ),
                LinearPercentIndicator(
                  barRadius: const Radius.circular(25),
                  padding: EdgeInsets.zero,
                  percent: 1 - differenceFromToday / differenceFromSelectedDate,
                  lineHeight: 10,
                  backgroundColor: Colors.black38,
                  progressColor: Colors.indigo.shade900,
                ),
              ],
            ),
          ] else ...[
            StyledButton(
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 1)),
                  firstDate: DateTime.now().add(const Duration(days: 1)),
                  lastDate: DateTime(9999),
                );
                if (pickedDate == null) return;
                setState(
                  () {
                    selectedDate = DateTime.now();
                    dueDate = pickedDate;
                    dateSelected = true;
                    differenceFromSelectedDate =
                        differenceCalcFromSelectedDate();
                    differenceFromToday = differenceCalcFromToday();
                  },
                );
                print(differenceFromSelectedDate);
                print(differenceFromToday);
              },
              child: const Text('원하는 D-Day를 선택해주세요.'),
            ),
          ],
        ],
      );
}
