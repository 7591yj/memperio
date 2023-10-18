import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:memperio/src/widgets.dart';

class LearnMenuSub extends StatefulWidget {
  const LearnMenuSub({this.id, this.name, this.tag, super.key});
  final String? id;
  final String? name;
  final String? tag;

  @override
  State<LearnMenuSub> createState() => _LearnMenuSubState();
}

class _LearnMenuSubState extends State<LearnMenuSub> {
  var tagList = [];
  var db = FirebaseFirestore.instance;
  String howMuchProbs = '1';
  int size = 1;

  @override
  void initState() {
    tagList = widget.tag!.split(',');
    db.collection("learn/${widget.id}/q").get().then((querySnapshot) {
      size = querySnapshot.size;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(widget.name!),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for (String tag in tagList) ...[TagContainer(tag: tag)]
            ],
          ),
          StyledContainer(
            title: '원하는 문제 수를 입력해주세요.',
            titleIcon: Icons.label_important_rounded,
            subButtonEnable: false,
            route: '',
            content: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          howMuchProbs = value;
                        },
                        decoration: InputDecoration(
                          labelText: '최소 1 ~ 최대 $size',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LimitRange(1, size)
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StyledButton(
                          child: const Text('시작하기'),
                          onPressed: () {
                            context.pushNamed('learn-page', pathParameters: {
                              'name': widget.name!,
                              'id': widget.id!,
                              'howMuch': howMuchProbs,
                            });
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LimitRange extends TextInputFormatter {
  LimitRange(
    this.minRange,
    this.maxRange,
  ) : assert(
          minRange <= maxRange,
        );

  final int minRange;
  final int maxRange;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var value = int.parse(newValue.text);
    if (value < minRange) {
      return TextEditingValue(text: minRange.toString());
    } else if (value > maxRange) {
      return TextEditingValue(text: maxRange.toString());
    }
    return newValue;
  }
}
