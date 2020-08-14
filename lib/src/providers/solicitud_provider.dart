import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:manos_a_la_obra/src/models/solicitud_model.dart';

class SolicitudDataProvider {
  Stream<QuerySnapshot> getSolicitudes() {
    return Firestore.instance.collection('solicitudes').snapshots();
  }

  Stream<QuerySnapshot> getSolicitudesUsuario(String idUsuario) {
    return Firestore.instance
        .collection('solicitudes')
        .where('id-cliente', isEqualTo: idUsuario)
        .snapshots();
  }

  Stream<QuerySnapshot> getNuevasSolicitudes(String idUsuario) {
    return Firestore.instance
        .collection('solicitudes')
        .where('id-proveedor', isEqualTo: idUsuario)
        .where("revisado", isEqualTo: false)
        .snapshots();
  }

  loadSolicitud(String coleccion, Solicitud datasolicitud) async {
    await Firestore.instance.collection(coleccion).add({
      'aceptado': datasolicitud.aceptado,
      'revisado': datasolicitud.revisado,
      'descripcion': datasolicitud.descripcion,
      'direccion': datasolicitud.direccion,
      'fechaFin': datasolicitud.fechaFin,
      'fechaInicio': datasolicitud.fechaInicio,
      'id-cliente': datasolicitud.idCliente,
      'id-proveedor': datasolicitud.idProveedor,
      'id-servicio': datasolicitud.idServicio,
      'cliente': datasolicitud.cliente,
      'servicio': datasolicitud.servicio,
      'terminado': datasolicitud.terminado,
    });
  }

  getImageUserSolicitud(path) async {
    StorageReference ref = FirebaseStorage.instance.ref().child(path);
    String fileURL = await ref.getDownloadURL();
    return fileURL;
  }

  deleteSolicitud(idDocument) async {
    await Firestore.instance
        .collection("solicitudes")
        .document(idDocument)
        .delete();
  }

  aceptarSolicitud(idSolicitud) async {
    await Firestore.instance
        .document("solicitudes/" + idSolicitud)
        .updateData({"aceptado": true, "revisado": true}).then(
            (value) => print("Solicitud Aceptada"));
  }

  rechazarSolicitud(idSolicitud) async {
    await Firestore.instance
        .document("solicitudes/" + idSolicitud)
        .updateData({"aceptado": false, "revisado": true}).then(
            (value) => print("Solicitud Rechazada"));
  }
}
