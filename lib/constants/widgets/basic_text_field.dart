import 'package:flutter/material.dart';

class BasicTextField extends StatelessWidget {

  final TextEditingController controller;
  final String title;
  final String hintText;

  const BasicTextField({
    required this.title,
    required this.hintText,
    required this.controller,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: TextField(
            decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                )
            ),
            controller: controller,
          ),
        )
      ],
    );
  }
}
