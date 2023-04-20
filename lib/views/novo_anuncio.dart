import 'package:flutter/material.dart';
import 'package:olx/views/widgets/botao_customizado.dart';
import 'dart:io';

class NovoAnuncio extends StatefulWidget {
  const NovoAnuncio({super.key});

  @override
  State<NovoAnuncio> createState() => _NovoAnuncioState();
}

class _NovoAnuncioState extends State<NovoAnuncio> {
  final List<File> _listaImagens = List.empty();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Novo Anúncio"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FormField<List>(
                  initialValue: _listaImagens,
                  validator: (imagens) {
                    if (imagens!.isEmpty) {
                      return "Necessário selecionar uma imagem!";
                    }
                    return null;
                  },
                  builder: (state) {
                    return Column(
                      children: [
                        Container(),
                        if (state.hasError) Text("[${state.errorText}]"),
                      ],
                    );
                  },
                ),
                const Row(
                  children: [
                    Text("Estado"),
                    Text("Categoria"),
                  ],
                ),
                const Text("Caixas de textos"),
                BotaoCustomizado(
                  texto: "Cadastrar anúncio",
                  corTexto: Colors.white,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {}
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
