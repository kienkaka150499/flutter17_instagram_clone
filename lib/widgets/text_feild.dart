import 'package:flutter/material.dart';

class TextFeildInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final TextInputType textInputType;

  const TextFeildInput({
    Key? key,
    required this.controller,
    required this.textInputType,
    required this.hintText,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder _inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: _inputBorder,
        focusedBorder: _inputBorder,
        enabledBorder: _inputBorder,
        hintText: hintText,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: textInputType,
      obscureText: isPassword,
    );
  }
}
