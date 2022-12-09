import 'package:flutter/material.dart';
import 'package:stattrack/styles/font_styles.dart';

/// Represents a header
/// A header need a title
/// It could also contain an icon in the top right corner
/// used as navigation. For this to work both the icon
/// widget and the callback function has to be passed as
/// parameter
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key, this.headerTitle, this.navButton, this.actions})
      : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  final String? headerTitle;
  final Widget? navButton;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: FittedBox(
        fit: BoxFit.fitWidth,
        child: Text(
          headerTitle ?? '',
          style: const TextStyle(
            fontSize: FontStyles.fsTitle1,
            fontWeight: FontStyles.fwTitle,
          ),
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: navButton,
      actions: actions,
    );
  }
}
