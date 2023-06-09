import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:olx/route_generator.dart';
import 'package:olx/views/anuncios.dart';

final ThemeData theme = ThemeData();

final ThemeData temaPadrao = ThemeData().copyWith(
    colorScheme: theme.colorScheme.copyWith(
        primary: const Color(0xff9c27b0), secondary: const Color(0xff7b1fa2)));

// final ThemeData temaPadrao = ThemeData(
//   primaryColor: const Color(0xff9c27b0),
// );

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    title: "OLX",
    home: const Anuncios(),
    theme: temaPadrao,
    initialRoute: "/",
    onGenerateRoute: RouteGenerator.generateRoute,
    debugShowCheckedModeBanner: false,
  ));
}
