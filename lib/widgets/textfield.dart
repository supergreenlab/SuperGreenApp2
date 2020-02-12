import 'package:flutter/material.dart';

class SGLTextField extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;
  final TextEditingController controller;
  final bool enabled;
  final TextInputAction textInputAction;
  final Function(String) onFieldSubmitted;
  final FocusNode focusNode;

  SGLTextField(
      {this.hintText,
      this.controller,
      this.onChanged,
      this.enabled,
      this.textInputAction,
      this.onFieldSubmitted,
      this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.black26),
          borderRadius: BorderRadius.circular(3)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
        child: TextField(
          textInputAction: TextInputAction.next,
          onSubmitted: onFieldSubmitted,
          enabled: enabled,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
          ),
          style: TextStyle(fontSize: 15),
          controller: controller,
          onChanged: onChanged,
          focusNode: focusNode,
        ),
      ),
    );
  }
}
