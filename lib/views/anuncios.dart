import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:olx/util/configuracoes.dart';

class Anuncios extends StatefulWidget {
  const Anuncios({super.key});

  @override
  State<Anuncios> createState() => _AnunciosState();
}

class _AnunciosState extends State<Anuncios> {
  List<String> itensMenu = [];
  List<DropdownMenuItem<String>> _listaItensDropEstados = [];
  List<DropdownMenuItem<String>> _listaItensDropCategorias = [];

  final _controller = StreamController<QueryDocumentSnapshot>.broadcast();

  String? _itemSelecionadoEstado;
  String? _itemSelecionadoCategoria;

  _escolhaMenuItem(String itemEscolhido) {
    switch (itemEscolhido) {
      case "Meus anúncios":
        Navigator.pushNamed(context, "/meus-anuncios");
        break;
      case "Entrar / Cadastrar":
        Navigator.pushNamed(context, "/login");
        break;
      case "Deslogar":
        _deslogarUsuario();
        break;

      default:
    }
  }

  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut();

    Navigator.pushNamed(context, "/login");
  }

  Future _verificaUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final usuarioLogado = auth.currentUser;

    if (usuarioLogado == null) {
      itensMenu = ["Entrar / Cadastrar"];
    } else {
      itensMenu = ["Meus anúncios", "Deslogar"];
    }
  }

  _carregarItensDropDown() {
    _listaItensDropCategorias = Configuracoes.getCategorias();

    _listaItensDropEstados = Configuracoes.getEstados();
  }

  Future<Stream<QuerySnapshot>> _adicionarListenerAnuncios() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db.collection("anuncios").snapshots();

    stream.listen((dados) {
      _controller.add(dados as QueryDocumentSnapshot<Object?>);
    });

    return stream;
  }

  @override
  void initState() {
    super.initState();
    _carregarItensDropDown();
    _verificaUsuarioLogado();
    _adicionarListenerAnuncios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OLX"),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context) {
              return itensMenu.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: Center(
                    child: DropdownButton(
                      iconEnabledColor: const Color(0xff9c27b0),
                      value: _itemSelecionadoEstado,
                      items: _listaItensDropEstados,
                      style: const TextStyle(fontSize: 22, color: Colors.black),
                      onChanged: (estado) {
                        setState(() {
                          _itemSelecionadoEstado = estado!;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.grey[200],
                width: 2,
                height: 60,
              ),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: Center(
                    child: DropdownButton(
                      iconEnabledColor: const Color(0xff9c27b0),
                      value: _itemSelecionadoCategoria,
                      items: _listaItensDropCategorias,
                      style: const TextStyle(fontSize: 22, color: Colors.black),
                      onChanged: (categoria) {
                        setState(() {
                          _itemSelecionadoCategoria = categoria!;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          StreamBuilder(
            stream: _controller.stream,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                case ConnectionState.active:
                case ConnectionState.done:
              }
              return Container();
            },
          )
        ],
      ),
    );
  }
}
