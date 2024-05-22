import 'package:flutter/material.dart';
import 'package:riddlepedia/constants/app_bar_type.dart';
import '../constants/app_color.dart';

class RpAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final RpAppBarType appBarType;
  final void Function()? onClosePageButtonPressen;
  final List<Widget> actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  const RpAppBar(
      {super.key,
      required this.title,
      this.onClosePageButtonPressen,
      this.appBarType = RpAppBarType.regular,
      this.actions = const []});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      backgroundColor: AppColor.mainColor,
      foregroundColor: Colors.white,
      leading: Visibility(
          visible: appBarType == RpAppBarType.back,
          child: BackButton(
            onPressed: onClosePageButtonPressen,
          )),
      actions: appBarType == RpAppBarType.modal
          ? [
              Visibility(
                  visible: appBarType == RpAppBarType.modal,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    tooltip: 'Close',
                    onPressed: onClosePageButtonPressen,
                  ))
            ]
          : actions,
    );
  }
}
