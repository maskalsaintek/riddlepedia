import 'package:flutter/material.dart';
import 'package:riddlepedia/core/extension/double.dart';

class FormInput extends StatelessWidget {
  final String hint;
  final String title;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? isVisible;
  final void Function(String value)? onChanged;
  final int? maxLine;
  const FormInput(
      {super.key,
      required this.hint,
      required this.title,
      this.controller,
      this.keyboardType,
      this.validator,
      this.prefixIcon,
      this.suffixIcon,
      this.isVisible,
      this.onChanged,
      this.maxLine = 1});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(alignment: Alignment.topLeft, child: Text(title)),
        4.0.height,
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          maxLines: maxLine,
          onChanged: onChanged,
          style: const TextStyle(color: Colors.black),
          obscureText: isVisible != null && !isVisible!,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: const BorderSide(width: 1, color: Colors.black38),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: const BorderSide(width: 1, color: Colors.black38),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              filled: true,
              isDense: true,
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              fillColor: Colors.transparent),
        )
      ],
    );
  }
}
