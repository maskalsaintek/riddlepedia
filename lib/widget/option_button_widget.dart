import 'package:flutter/material.dart';
import 'package:riddlepedia/core/extension/double.dart';

class OptionButton extends StatelessWidget {
  final String title;
  final String hint;
  final VoidCallback? onPressed;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const OptionButton({
    Key? key,
    required this.title,
    required this.hint,
    this.onPressed,
    this.prefixIcon,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
        ),
        4.0.height,
        Material(
          borderRadius: BorderRadius.circular(4.0),
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(width: 1, color: Colors.black38),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (prefixIcon != null) prefixIcon!,
                      SizedBox(width: prefixIcon != null ? 8.0 : 0),
                      Text(
                        hint,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  if (suffixIcon != null) suffixIcon!,
                  const Icon(Icons.keyboard_arrow_down, color: Colors.black),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
