import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/user_info/get_user_info.dart';

const message = "Not logged";

class BonusStatusPanel extends StatelessWidget {
//  final String clientName;
//  final int points;

  BonusStatusPanel();

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<GetUserInfoBloc>(context);

    return BlocBuilder(
      builder: _builder,
      bloc: bloc,
    );
  }

  _buildStatusPanel(String clientName, int points) {
    if (clientName == null) {
      return null;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            "$clientName",
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
        Expanded(
            child: TextField(
          decoration: InputDecoration(hintText: 'Input your code'),
        )),
        IconButton(
          icon: Icon(Icons.check),
          onPressed: () {},
        )
      ],
    );
  }

  Widget _builder(BuildContext context, GetUserInfoState state) {
    String clientName;
    int points;
    if (state is SuccessfulState){
      clientName = state.clientName;
      points = state.points;
    }

    return Container(
        height: 100,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildActionPanels(),
            SizedBox(
              height: 8,
            ),
            _buildStatusPanel(clientName, points) ??
                Center(
                  child: Text(message),
                ),
          ],
        ),
      );
  }
}
