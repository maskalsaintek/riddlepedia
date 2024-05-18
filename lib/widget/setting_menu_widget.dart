import 'package:flutter/material.dart';
import 'package:riddlepedia/core/extension/double.dart';
import '../constants/app_color.dart';

class SettingMenu extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subTitle;
  final void Function()? onPressed;

  const SettingMenu({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onPressed,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          children: [
            20.0.height,
            Row(
              children: [
                Icon(icon, color: AppColor.secondaryColor),
                12.0.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                        textAlign: TextAlign.left),
                    2.5.height,
                    Text(subTitle,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 13.0))
                  ],
                ),
                const Spacer(),
                const Icon(Icons.chevron_right)
              ],
            ),
            10.0.height,
            const Divider(thickness: 0.5)
          ],
        ));
  }
}
