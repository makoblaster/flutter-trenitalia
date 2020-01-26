import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Palette{
  static const Color black = Color(0xff0C2333);
  static const Color blue = Color(0xff3376BC);
  static const Color lightblue = Color(0xff91BBE5);
  static const Color red = Color(0xffC14D7C);
  static const Color intercity = Color(0xffF4A82C);
  static const Color darkGrey = Color(0xff121212);
  static const Map<int, Color> color = {
    50: Color.fromRGBO(193, 77, 124, .1),
    100: Color.fromRGBO(193, 77, 124, .2),
    200: Color.fromRGBO(193, 77, 124, .3),
    300: Color.fromRGBO(193, 77, 124, .4),
    400: Color.fromRGBO(193, 77, 124, .5),
    500: Color.fromRGBO(193, 77, 124, .6),
    600: Color.fromRGBO(193, 77, 124, .7),
    700: Color.fromRGBO(193, 77, 124, .8),
    800: Color.fromRGBO(193, 77, 124, .9),
    900: Color.fromRGBO(193, 77, 124, 1),
  };
  static const MaterialColor materialRed = MaterialColor(0xffC14D7C, color);
}
