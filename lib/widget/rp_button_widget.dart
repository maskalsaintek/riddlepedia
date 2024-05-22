import 'package:flutter/material.dart';
import '../constants/app_color.dart';

class RpButton extends StatelessWidget {
  final String title;
  final void Function()? onPressed;

  const RpButton({
    super.key,
    required this.title,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: AppColor.secondaryColor,
          borderRadius: BorderRadius.circular(6)),
      child: TextButton(
          onPressed: onPressed,
          child: Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14))),
    );
  }
}
