import 'package:flutter/material.dart';

PopupMenuItem<String> kBuildMenuItem(
    IconData icon, String label, String value) {
  return PopupMenuItem<String>(
    value: value,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(icon),
        SizedBox(
          width: 8,
        ),
        Text(label),
      ],
    ),
  );
}
