import 'package:flutter/material.dart';
import 'package:olx/home.dart';

final ThemeData theme = ThemeData();

final ThemeData temaPadrao = ThemeData().copyWith(
    colorScheme: theme.colorScheme.copyWith(
        primary: const Color(0xff9c27b0), secondary: const Color(0xff7b1fa2)));

// final ThemeData temaPadrao = ThemeData(
//   primaryColor: const Color(0xff9c27b0),
// );

void main() {
  runApp(MaterialApp(
    title: "OLX",
    home: const Home(),
    theme: temaPadrao,
    debugShowCheckedModeBanner: false,
  ));
}
