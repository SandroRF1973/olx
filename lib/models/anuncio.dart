import 'package:cloud_firestore/cloud_firestore.dart';

class Anuncio {
  String? _id;
  String? _estado;
  String? _categoria;
  String? _titulo;
  String? _preco;
  String? _telefone;
  String? _descricao;
  List<String>? _fotos;

  Anuncio() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference anuncios = db.collection("meus_anuncios");
    id = anuncios.doc().id;

    fotos = [];
  }

  String get id => _id!;

  set id(String value) {
    _id = value;
  }

  String get estado => _estado!;

  set estado(String value) {
    _estado = value;
  }

  String get categoria => _categoria!;

  set categoria(String value) {
    _categoria = value;
  }

  String get titulo => _titulo!;

  set titulo(String value) {
    _titulo = value;
  }

  String get preco => _preco!;

  set preco(String value) {
    _preco = value;
  }

  String get telefone => _telefone!;

  set telefone(String value) {
    _telefone = value;
  }

  String get descricao => _descricao!;

  set descricao(String value) {
    _descricao = value;
  }

  List<String> get fotos => _fotos!;

  set fotos(List<String> value) {
    _fotos = value;
  }
}
