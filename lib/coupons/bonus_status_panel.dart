import 'package:flutter/material.dart';

const message = "Not logged";

class BonusStatusPanel extends StatelessWidget {
  final String customerName;
  final int points;


  BonusStatusPanel({this.customerName, this.points});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,

      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildActionPanels(),
          SizedBox(height: 8,),
          _buildStatusPanel() ??
              Center(child: Text(message),),

        ],
      ),
    );
  }

  _buildStatusPanel() {
    if (customerName == null) {
      return null;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            "$customerName",
            textAlign: TextAlign.start,
          ),
          new SizedBox(
            width: 16,
            child: Text(
              "-",
              textAlign: TextAlign.center,
            ),
          ),
          Text("${points?.toString()} points" ?? "")
        ],
      ),
    );
  }

  _buildActionPanels() {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.camera),
          onPressed: () {},
        ),
        Expanded(child: TextField(decoration: InputDecoration(hintText: 'Input your code'),)),
        IconButton(
          icon: Icon(Icons.check),
          onPressed: () {},
        )
      ],
    );
  }
}
