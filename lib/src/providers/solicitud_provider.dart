import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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
        .snapshots();
  }

  loadSolicitud(String coleccion, Solicitud datasolicitud) async {
    await Firestore.instance.collection(coleccion).add({
      'aceptado': datasolicitud.aceptado,
      'descripcion': datasolicitud.descripcion,
      'direccion': datasolicitud.direccion,
      'fechaFin': datasolicitud.fechaFin,
      'fechaInicio': datasolicitud.fechaInicio,
      'id-cliente': datasolicitud.idCliente,
      'id-proveedor': datasolicitud.idProveedor,
      'id-servicio': datasolicitud.idServicio,
      'servicio': datasolicitud.servicio,
      'terminado': datasolicitud.terminado,
    });
  }

  deleteSolicitud(idDocument) async {
    await Firestore.instance
        .collection("solicitudes")
        .document(idDocument)
        .delete();
  }
}
