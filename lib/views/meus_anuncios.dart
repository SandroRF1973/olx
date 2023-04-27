import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:olx/views/widgets/item_anuncio.dart';

class MeusAnuncios extends StatefulWidget {
  const MeusAnuncios({super.key});

  @override
  State<MeusAnuncios> createState() => _MeusAnunciosState();
}

class _MeusAnunciosState extends State<MeusAnuncios> {
  final _controller = StreamController<QuerySnapshot>.broadcast();

  Stream<QuerySnapshot> _adicionarListenerAnuncios() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("meus_anuncios")
        .doc("idUsuario")
        .collection("anuncios")
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Anúncios"),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, "/novo-anuncio");
        },
      ),
<<<<<<< HEAD
      body: StreamBuilder(
          stream: _controller.stream,
          builder: ((context, snapshot) {
            return ListView.builder(
                itemCount: 8,
                itemBuilder: (_, indice) {
                  return const ItemAnuncio();
                });
          })),
=======
      body: ListView.builder(
          itemCount: 4,
          itemBuilder: (_, indice) {
            return const ItemAnuncio();
          }),
>>>>>>> b4ef5cd2b6679873367702ab575f772e398043a2
    );
  }
}
