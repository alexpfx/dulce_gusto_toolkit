import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddCodeWidget extends StatefulWidget {
  Function onAddButtonPressed;

  AddCodeWidget(this.onAddButtonPressed);

  @override
  _AddCodeWidgetState createState() => _AddCodeWidgetState();
}

class _AddCodeWidgetState extends State<AddCodeWidget> {
  var _textController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  var _isCodeValid = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildActionPanels();
  }

  _buildActionPanels() {
    return Form(
      key: _formKey,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.camera),
            onPressed: () {},
          ),
          Expanded(
              child: TextFormField(
                validator: _validateInput,
                inputFormatters: [BlacklistingTextInputFormatter(
                    new RegExp(r"\s\b|\b\s")
                )],
                maxLength: 12,
                controller: _textController,
                decoration: const InputDecoration(hintText: 'Input your bonus code'),
              )),
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                widget.onAddButtonPressed(_textController.value.text);
                _textController.clear();
              } else {
                showInvalidInput(context); //adicionar mensagem erro.
              }
            },
          )
        ],
      ),
    );
  }

  String _validateInput(String value) {
    _isCodeValid = false;
    if (value.isEmpty) {
      return "";
    }

    var wb = value.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
    if (wb.length != 12) {
      return "O código deve ter 12 caracteres sem espaços.";
    }
    return null;
  }

  void showInvalidInput(BuildContext context) {
    final SnackBar snackbar = SnackBar(
      content: Text('Código não é valido!'),
    );
    Scaffold.of(context).showSnackBar(snackbar);
  }
}



