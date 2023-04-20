import 'package:flutter/material.dart';

class BotaoCustomizado extends StatelessWidget {
  //const BotaoCustomizado({super.key});

  final String? texto;
  final Color? corTexto;
  final VoidCallback? onPressed;

  const BotaoCustomizado(
      {super.key,
      @required this.texto,
      this.corTexto = Colors.white,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          backgroundColor: const Color(0xff9c27b0),
          foregroundColor: corTexto,
          padding: const EdgeInsets.fromLTRB(32, 16, 32, 16)),
      child: Text(texto!),
    );
  }
}
