import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/user_info/get_user_info.dart';

const message = "";

class ClientInfoPanelWidget extends StatelessWidget {
  final VoidCallback onChangeCredentials;
  final VoidCallback onRefresh;

  ClientInfoPanelWidget(this.onChangeCredentials, this.onRefresh);

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<GetUserInfoBloc>(context);

    return BlocBuilder<GetUserInfoBloc, GetUserInfoState>(
      builder: _builder,
      bloc: bloc,
    );
  }

  _buildStatusPanel(String clientName, int points) {
    if (clientName == null) {
      return SizedBox.shrink();
    }

    return Row(
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
    );
  }

  Widget _builder(BuildContext context, GetUserInfoState state) {
    String clientName;
    int points;
    print(state);
    if (state is SuccessfulState) {
      clientName = state.clientName;
      points = state.points;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Container(
        width: double.infinity,
        child: _buildStatusPanel(clientName, points),
      ),
    );
  }
}
