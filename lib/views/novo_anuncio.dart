import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx/models/anuncio.dart';
import 'package:olx/views/widgets/botao_customizado.dart';
import 'package:olx/views/widgets/input_customizado.dart';
import 'dart:io';
import 'package:flutter/services.dart';
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
  late Anuncio _anuncio;
  late BuildContext _dialogContext;

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

  _salvarAnuncio() async {
    _abrirDialog(_dialogContext);

    await _uploadImagens();

    FirebaseAuth auth = FirebaseAuth.instance;
    final usuarioLogado = auth.currentUser!;
    String idUsuarioLogado = usuarioLogado.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection("meus_anuncios")
        .doc(idUsuarioLogado)
        .collection("anuncios")
        .doc(_anuncio.id)
        .set(_anuncio.toMap())
        .then((_) {
      Navigator.pop(_dialogContext);
      Navigator.pop(context);
    });
  }

  Future _uploadImagens() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference pastaRaiz = storage.ref();

    for (var imagem in _listaImagens) {
      String nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();

      Reference arquivo =
          pastaRaiz.child("meus_anuncios").child(_anuncio.id).child(nomeImagem);

      UploadTask uploadTask = arquivo.putFile(imagem!);

      TaskSnapshot taskSnapshot = await uploadTask;

      String url = await taskSnapshot.ref.getDownloadURL();
      _anuncio.fotos.add(url);
    }
  }

  _abrirDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(mainAxisSize: MainAxisSize.min, children: const [
              CircularProgressIndicator(),
              SizedBox(
                height: 20,
              ),
              Text("Salvando anúncio...")
            ]),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _carregarItensDropDown();

    _anuncio = Anuncio.gerarId();
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
                          onSaved: (estado) {
                            _anuncio.estado = estado!;
                          },
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
                          onSaved: (categoria) {
                            _anuncio.categoria = categoria!;
                          },
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 15, top: 15),
                  child: InputCustomizado(
                    hint: "Título",
                    onSaved: (titulo) {
                      _anuncio.titulo = titulo!;
                      return null;
                    },
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .valido(valor);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    hint: "Preço",
                    onSaved: (preco) {
                      _anuncio.preco = preco!;
                      return null;
                    },
                    type: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      RealInputFormatter(moeda: true)
                    ],
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .valido(valor);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    hint: "Telefone",
                    onSaved: (telefone) {
                      _anuncio.telefone = telefone!;
                      return null;
                    },
                    type: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter()
                    ],
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .valido(valor);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    hint: "Descrição (200 caracteres)",
                    onSaved: (descricao) {
                      _anuncio.descricao = descricao!;
                      return null;
                    },
                    //maxLines: null,
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .maxLength(200, msg: "Máximo de 200 caracteres")
                          .valido(valor);
                    },
                  ),
                ),
                BotaoCustomizado(
                  texto: "Cadastrar anúncio",
                  corTexto: Colors.white,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      _dialogContext = context;

                      _salvarAnuncio();
                    }
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
