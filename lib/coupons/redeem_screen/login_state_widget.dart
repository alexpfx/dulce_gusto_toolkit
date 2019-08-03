import 'package:dulce_gusto_toolkit/coupons/bloc/connection/conn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginStateWidget extends StatelessWidget {
  final redeemButtonPress;
  final connectButtonPress;

  LoginStateWidget({this.redeemButtonPress, this.connectButtonPress});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<ConnectionBloc>(context),
      builder: (BuildContext context, ConnState state) {
        return _build(state.asEnum);
      },
    );
  }

  Widget _build(EnumConnectionState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: _buildStatus(state),
        ),
        RaisedButton.icon(
            onPressed: redeemButtonPress,
            icon: Icon(Icons.check),
            label: Text("Resgatar Items")),
      ],
    );
  }

  List<Widget> _buildStatus(EnumConnectionState status) {
    TextStyle style = TextStyle(fontSize: 14);
    var connectButton = InkWell(
      child: Container(width: 48, height: 48, child: Icon(Icons.refresh)),
      onTap: connectButtonPress,
    );

    switch (status) {
      case EnumConnectionState.initial:
        return [
          connectButton,
          Text("Desconectado", style: style.copyWith(color: Colors.red)),
        ];
      case EnumConnectionState.connecting:
        return [
          Padding(
            padding: EdgeInsets.all(8),
            child: Container(
                width: 24, height: 24, child: CircularProgressIndicator()),
          ),
          Text(
            "Conectando",
            style: style.copyWith(color: Colors.yellow),
          ),
        ];
      case EnumConnectionState.login_succefull:
        return [
          connectButton,
          Text(
            "Conectado",
            style: style.copyWith(color: Colors.green),
          ),
        ];
    }
  }
}
