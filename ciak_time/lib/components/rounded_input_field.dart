import 'package:ciak_time/components/text_field_container.dart';
import 'package:ciak_time/constants.dart';
import 'package:flutter/material.dart';

class RoundedInputField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;

  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon = Icons.email,
    this.onChanged,
  }) : super(key: key);

  @override
  _RoundedInputFieldState createState() => _RoundedInputFieldState();
}

class _RoundedInputFieldState extends State<RoundedInputField> {
  @override
  Widget build(BuildContext context) {

    return TextFieldContainer(
      child: TextFormField(
        controller: loginUsernameController,
        onChanged: widget.onChanged,
        style: TextStyle(color: textFieldColor, fontWeight: FontWeight.w600),
        cursorColor: themePrimaryColor,
        decoration: InputDecoration(
          icon: Icon(
            widget.icon,
            color: themePrimaryColor,
          ),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontSize: height * 0.02,
            fontFamily: 'Quicksand',
            color: hintTextFieldColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
