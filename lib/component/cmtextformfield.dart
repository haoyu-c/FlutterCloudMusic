import 'package:flutter/material.dart';

class CMTextFormField extends StatelessWidget {
  final TextInputType keyboardType;
  final bool obscureText;
  final AutovalidateMode autovalidateMode;
  final TextStyle style;
  final Icon prefixIcon;
  final String hintText;
  final FormFieldValidator<String> validator;
  final FormFieldSetter<String> onSaved;
  final ValueChanged<String> onChanged;

  const CMTextFormField(
      {Key key,
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      this.autovalidateMode = AutovalidateMode.onUserInteraction,
      this.style = const TextStyle(color: Colors.black),
      this.prefixIcon,
      this.hintText,
      this.validator,
      this.onSaved,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      obscureText: obscureText,
      autovalidateMode: autovalidateMode,
      onChanged: onChanged,
      style: style,
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(top: 14.0),
        prefixIcon: prefixIcon,
        hintText: hintText,
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }
}
