import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:manos_a_la_obra/src/models/direccion_model.dart';

class DireccionProvider {
  Stream<QuerySnapshot> getDirecciones(String id) {
    return Firestore.instance.collection('usuario').document(id).collection('direccion').snapshots();
  }

  Future<void> createDireccion(Direccion direccion) async {
    final userId = await getIdCurrentUser();
    final res = await Firestore.instance.collection('usuario').document(userId).collection('direccion').add({
      'nombre': direccion.nombre,
      'ubicacionMap': direccion.ubicacionMap, 
      'callePrincipal': direccion.callePrincipal,
      'numeroVivienda': direccion.numeroVivienda,
      'calleSecundaria': direccion.calleSecundaria,
      'referencia': direccion.referencia,
      'latitud': direccion.latitud,
      'longitud': direccion.longitud,
    });
  }
  Future<void> editarDireccion(Direccion direccion) async {
    final userId = await getIdCurrentUser();
    await Firestore.instance.collection('usuario').document(userId).collection('direccion').document(direccion.id).updateData({
      'nombre': direccion.nombre,
      'ubicacionMap': direccion.ubicacionMap,
      'callePrincipal': direccion.callePrincipal,
      'numeroVivienda': direccion.numeroVivienda,
      'calleSecundaria': direccion.calleSecundaria,
      'referencia': direccion.referencia,
      'latitud': direccion.latitud,
      'longitud': direccion.longitud,
    });
  }
  Future<String> getIdCurrentUser() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser user = await _auth.currentUser();
    return user.uid;
  }
  deleteDireccion(id) async {
    final userId = await getIdCurrentUser();
    await Firestore.instance
        .collection("usuario").document(userId).collection('direccion')
        .document(id)
        .delete();
  }
}