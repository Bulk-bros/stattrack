import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Authentication buttons
/// Used in both signin and signup page
///
/// * [onPressed], function called when button is pressed
/// * [label], text label displayed on button
/// * [iconPath], path to an icon
/// * [iconAlt], alt text describing the icon
/// * [bgColor], background color of the buttn
/// * [textColor], text color of the button
/// * [height], height of the button, default 50px
/// * [borderRadius], rounding or the edges, default 5px
class AuthButton extends StatelessWidget {
  const AuthButton({
    Key? key,
    this.onPressed,
    required this.label,
    required this.iconPath,
    required this.iconAlt,
    this.bgColor,
    this.textColor,
    this.height = 50.0,
    this.borderRadius = 5,
  }) : super(key: key);

  final String label;
  final String iconPath;
  final String iconAlt;
  final Color? bgColor;
  final Color? textColor;
  final double height;
  final double borderRadius;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            primary: bgColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(borderRadius),
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                iconPath,
                semanticsLabel: iconAlt,
                color: textColor,
                height: 30.0,
              ),
              const SizedBox(
                width: 10.0,
              ),
              Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16.0,
                ),
              ),
            ],
          )),
    );
  }
}
