import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:manos_a_la_obra/src/models/categoria_servicio_model.dart';

class CategoriasServiciosProviders{

  Stream<QuerySnapshot> getCategorias() {
    return Firestore.instance.collection('categoria-servicio').snapshots();
  }
}