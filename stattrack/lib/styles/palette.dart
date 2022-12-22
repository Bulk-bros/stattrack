import 'package:flutter/material.dart';

/// Defines the custom primary swatch for the app theme
/// If no shade is specified the "400" shade version is used as a default fallback
class Palette {
  static const MaterialColor accent = MaterialColor(
    0x51cf66,
    <int, Color>{
      50: Color(0xff2b8a3e),
      100: Color(0xff2f9e44),
      200: Color(0xff37b24d),
      300: Color(0xff40c057),
      400: Color(0xff51cf66),
      500: Color(0xff69db7c),
      600: Color(0xff8ce99a),
      700: Color(0xffb2f2bb),
      800: Color(0xffd3f9d8),
      900: Color(0xffebfbee),
    },
  );

  static const MaterialColor main = MaterialColor(
    0x51cf66,
    <int, Color>{
      0: Color(0xfff8f9fa),
      100: Color(0xfff1f3f5),
      200: Color(0xffe9ecef),
      300: Color(0xffdee2e6),
      400: Color(0xffced4da),
      500: Color(0xffadb5bd),
      600: Color(0xff868e96),
      700: Color(0xff495057),
      800: Color(0xff343a40),
      900: Color(0xff212529),
    },
  );

  static const MaterialColor error = MaterialColor(0xfa5252, <int, Color>{
    0: Color(0xfffff5f5),
    100: Color(0xffffe3e3),
    200: Color(0xffffc9c9),
    300: Color(0xffffa8a8),
    400: Color(0xffff8787),
    500: Color(0xffff6b6b),
    600: Color(0xfffa5252),
    700: Color(0xfff03e3e),
    800: Color(0xffe03131),
    900: Color(0xffc92a2a),
  });
}
