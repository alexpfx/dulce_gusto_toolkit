import 'package:dulce_gusto_toolkit/page.dart';
import 'package:flutter/material.dart';

class TimerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Page(
      title: 'Dolce Gusto Timer',
      body: _pageBuilder(context),
    );
  }

  Widget _pageBuilder(BuildContext context) {
    return Text('Timer');
  }
}
