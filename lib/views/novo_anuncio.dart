import 'package:flutter/material.dart';
import 'package:olx/views/widgets/botao_customizado.dart';

class NovoAnuncio extends StatefulWidget {
  const NovoAnuncio({super.key});

  @override
  State<NovoAnuncio> createState() => _NovoAnuncioState();
}

class _NovoAnuncioState extends State<NovoAnuncio> {
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
                //FormField(),
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
