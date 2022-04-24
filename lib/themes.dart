import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skan/widgets/file/file_item_slider.dart';

import '../data/scan_file.dart';

class CustomThemes{
  ThemeData light = ThemeData(
    brightness: Brightness.light,
    bottomAppBarColor: Color.fromARGB(255, 36, 36, 36),
    highlightColor: Color.fromARGB(255, 0, 159, 184),
    backgroundColor: Color.fromARGB(255, 241, 241, 241),
    primaryColor: Color.fromARGB(255, 210, 210, 210),
    primaryColorDark: Color.fromARGB(255, 190, 190, 190),
    textTheme: TextTheme (
      headline1: TextStyle (
        color: Color.fromARGB(255, 25, 25, 25),
        fontSize: 18,
        fontWeight: FontWeight.normal,
      ),
      bodyText1: TextStyle (
        color: Color.fromARGB(255, 36, 36, 36),
        fontSize: 14,
        height: 1.8,
        fontWeight: FontWeight.normal,
      ),
    ),
    iconTheme: IconThemeData (
      color: Color.fromARGB(255, 90, 90, 90),
  ),
    errorColor: Color.fromARGB(255, 243, 83, 83),
  );

  ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    bottomAppBarColor: Color.fromARGB(255, 240, 162, 2),
    highlightColor: Color.fromARGB(255, 237, 69, 69),
    backgroundColor: Color.fromARGB(255, 36, 36, 36),
    primaryColor: Color.fromARGB(255, 25, 25, 25),
    primaryColorDark: Color.fromARGB(255, 15, 15, 15),
    textTheme: TextTheme (
      headline1: TextStyle (
        color: Color.fromARGB(255, 241, 241, 241),
        fontSize: 18,
      ),
      bodyText1: TextStyle (
        color: Color.fromARGB(255, 118, 118, 118),
        fontSize: 14,
        height: 1.8,
      ),
    ),
    iconTheme: IconThemeData (
      color: Color.fromARGB(255, 63, 72, 81),
    ),
    errorColor: Color.fromARGB(255, 243, 83, 83),
  );

  IconThemeData getIconColor(STATUS status, context) {
    if (status == STATUS.RUNNING) {
      return IconThemeData(color: Color.fromARGB(255, 244, 215, 111));
    }
    if (status == STATUS.DONE) {
      return IconThemeData(color: Color.fromARGB(255, 36, 96, 155));
    }
    return AdaptiveTheme.of(context).theme.iconTheme;
  }

  Color getFileSliderColor(FileItemSliderType status, context) {
    if (status == FileItemSliderType.progress) {
      return Color.fromARGB(255, 244, 215, 111);
    }
    return AdaptiveTheme.of(context).theme.primaryColor;
  }
}