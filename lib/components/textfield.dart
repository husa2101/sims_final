import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {

  final controller;
  final String hintText;
  final bool abscureText;

  const MyTextField({

    super.key,
    required this.abscureText,
    required this.hintText,
    required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextField(
        controller: controller,   // we use it to access the content things that user type in
        obscureText: abscureText,
        decoration: InputDecoration(
          enabledBorder:
          const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
          const OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
          fillColor: Colors.grey.shade500,
          filled: true,
          hintText: hintText,  // tell the user what should be typed in
        ),
      ),
    );
  }
}
