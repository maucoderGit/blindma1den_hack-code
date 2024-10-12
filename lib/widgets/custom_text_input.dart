import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  final String hintText;
  final ValueChanged userTyped;
  final String defaultValue;
  final bool obscure;
  final TextInputType keyboard;

  const CustomTextInput({super.key, required this.hintText, required this.userTyped, required this.obscure,this.keyboard=TextInputType.multiline, required this.defaultValue});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.only(left: 10),
      height: 160,
      child: TextField(
        onChanged: userTyped,
        keyboardType: keyboard,
        controller: TextEditingController(text: defaultValue),
        autofocus: false,
        obscureText: obscure?true:false,
        expands: true,
        minLines: null,
        maxLines: null,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}