import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx/views/widgets/botao_customizado.dart';
import 'dart:io';

import 'package:validadores/Validador.dart';

class NovoAnuncio extends StatefulWidget {
  const NovoAnuncio({super.key});

  @override
  State<NovoAnuncio> createState() => _NovoAnuncioState();
}

class _NovoAnuncioState extends State<NovoAnuncio> {
  final List<File?> _listaImagens = [];
  final List<DropdownMenuItem<String>> _listaItensDropEstados = [];
  final List<DropdownMenuItem<String>> _listaItensDropCategorias = [];
  final _formKey = GlobalKey<FormState>();

  String? _itemSelecionadoEstado;
  String? _itemSelecionadoCategoria;

  _selecionarImagemGaleria() async {
    File? imagemSelecionada;

    PickedFile? pickedFile =
        // ignore: invalid_use_of_visible_for_testing_member
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imagemSelecionada = File(pickedFile.path);

      setState(() {
        _listaImagens.add(imagemSelecionada);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _carregarItensDropDown();
  }

  _carregarItensDropDown() {
    _listaItensDropCategorias.add(const DropdownMenuItem(
      value: "auto",
      child: Text("Automóvel"),
    ));

    _listaItensDropCategorias.add(const DropdownMenuItem(
      value: "imovel",
      child: Text("Imóvel"),
    ));

    _listaItensDropCategorias.add(const DropdownMenuItem(
      value: "eletro",
      child: Text("Eletrônicos"),
    ));

    _listaItensDropCategorias.add(const DropdownMenuItem(
      value: "moda",
      child: Text("Moda"),
    ));

    _listaItensDropCategorias.add(const DropdownMenuItem(
      value: "esportes",
      child: Text("Esportes"),
    ));

    for (var estado in Estados.listaEstadosSigla) {
      _listaItensDropEstados.add(DropdownMenuItem(
        value: estado,
        child: Text(estado),
      ));
    }
  }

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
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _listaImagens.length + 1,
                              itemBuilder: (context, indice) {
                                if (indice == _listaImagens.length) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: GestureDetector(
                                      onTap: () {
                                        _selecionarImagemGaleria();
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.grey[400],
                                        radius: 50,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add_a_photo,
                                                size: 40,
                                                color: Colors.grey[100],
                                              ),
                                              Text(
                                                "Adicionar",
                                                style: TextStyle(
                                                    color: Colors.grey[100]),
                                              ),
                                            ]),
                                      ),
                                    ),
                                  );
                                }
                                if (_listaImagens.isNotEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) => Dialog(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Image.file(_listaImagens[
                                                          indice]!),
                                                      TextButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              _listaImagens
                                                                  .removeAt(
                                                                      indice);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            });
                                                          },
                                                          style: TextButton
                                                              .styleFrom(
                                                                  foregroundColor:
                                                                      Colors
                                                                          .red),
                                                          child: const Text(
                                                              "Excluir"))
                                                    ],
                                                  ),
                                                ));
                                      },
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage:
                                            FileImage(_listaImagens[indice]!),
                                        child: Container(
                                          color: const Color.fromRGBO(
                                              255, 255, 255, 0.4),
                                          alignment: Alignment.center,
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }

                                return Container();
                              }),
                        ),
                        if (state.hasError)
                          Text(
                            "[${state.errorText}]",
                            style: const TextStyle(
                                color: Colors.red, fontSize: 14),
                          ),
                      ],
                    );
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: DropdownButtonFormField(
                          value: _itemSelecionadoEstado ?? "SP",
                          hint: const Text("Estados"),
                          style: const TextStyle(
                              color: Colors.black, fontSize: 20),
                          items: _listaItensDropEstados,
                          validator: (valor) {
                            return Validador()
                                .add(Validar.OBRIGATORIO,
                                    msg: "Campo obrigatório")
                                .valido(valor);
                          },
                          onChanged: (valor) {
                            setState(() {
                              _itemSelecionadoEstado = valor;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: DropdownButtonFormField(
                          value: _itemSelecionadoCategoria ?? "auto",
                          hint: const Text("Categorias"),
                          style: const TextStyle(
                              color: Colors.black, fontSize: 20),
                          items: _listaItensDropCategorias,
                          validator: (valor) {
                            return Validador()
                                .add(Validar.OBRIGATORIO,
                                    msg: "Campo obrigatório")
                                .valido(valor);
                          },
                          onChanged: (valor) {
                            setState(() {
                              _itemSelecionadoCategoria = valor;
                            });
                          },
                        ),
                      ),
                    ),
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
