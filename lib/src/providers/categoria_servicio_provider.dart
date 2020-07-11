import 'package:cloud_firestore/cloud_firestore.dart';

class CategoriasServiciosProviders{

  Stream<QuerySnapshot> getCategorias() {
    return Firestore.instance.collection('categoria-servicio').snapshots();
  }
}
