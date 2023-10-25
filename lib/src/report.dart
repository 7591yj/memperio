import 'package:flutter/material.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  String _welcome() {
    var timeNow = DateTime.now().hour;
    if (timeNow <= 11) {
      return '좋은 아침입니다';
    } else if (timeNow <= 17) {
      return '';
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
