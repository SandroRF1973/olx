import 'package:flutter/material.dart';
import 'package:olx/views/anuncios.dart';
import 'package:olx/views/login.dart';
import 'package:olx/views/meus_anuncios.dart';
import 'package:olx/views/novo_anuncio.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => const Anuncios());
      case "/login":
        return MaterialPageRoute(builder: (_) => const Login());
      case "/meus-anuncios":
        return MaterialPageRoute(builder: (_) => const MeusAnuncios());
      case "/novo-anuncio":
        return MaterialPageRoute(builder: (_) => const NovoAnuncio());
      default:
        _erroRota();
    }
  }

  static Route<dynamic> _erroRota() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Tela não encontrada!"),
        ),
        body: const Center(
          child: Text("Tela não encontrada!"),
        ),
      );
    });
  }
}
