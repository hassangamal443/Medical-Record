import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  final bool enabled;
  const TextFieldInput({super.key,
    required this.textEditingController,
    this.isPass = false,
    required this.textInputType,
    required this.hintText,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(30),
    );
    return TextField(
      enabled: enabled,
      controller: textEditingController,
      decoration: InputDecoration(
          hintText: textEditingController.text.isEmpty ? hintText : null,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8)
      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}
