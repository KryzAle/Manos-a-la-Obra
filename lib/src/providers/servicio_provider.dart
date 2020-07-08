import 'package:cloud_firestore/cloud_firestore.dart';

class ServicioProvider{

  Stream<QuerySnapshot> getServicios() {
    return Firestore.instance.collection('servicio').snapshots();
  }

}