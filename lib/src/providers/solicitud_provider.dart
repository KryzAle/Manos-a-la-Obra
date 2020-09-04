import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:manos_a_la_obra/src/models/solicitud_model.dart';
import 'package:manos_a_la_obra/src/models/usuario_model.dart';
import 'package:manos_a_la_obra/src/providers/push_notification_provider.dart';
import 'package:manos_a_la_obra/src/providers/user_data_provider.dart';

class SolicitudDataProvider {
  final usuarioProvider = UserDataProvider();
  final pushProvider = PushNotificationProvider();

  Stream<QuerySnapshot> getSolicitudes() {
    return Firestore.instance.collection('solicitudes').snapshots();
  }

  Stream<QuerySnapshot> getSolicitudesUsuario(String idUsuario) {
    return Firestore.instance
        .collection('solicitudes')
        .where('id-cliente', isEqualTo: idUsuario)
        .where("puntuado", isEqualTo: false)
        .where("canceladoProveedor", isEqualTo: false)
        .where("canceladoCliente", isEqualTo: false)
        .orderBy("fechaSolicitud", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getNuevasSolicitudes(String idUsuario) {
    return Firestore.instance
        .collection('solicitudes')
        .where('id-proveedor', isEqualTo: idUsuario)
        .where("revisado", isEqualTo: false)
        .where("canceladoCliente", isEqualTo: false)
        .orderBy("fechaSolicitud", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getMisSolicitudesActivas(String idUsuario) {
    return Firestore.instance
        .collection('solicitudes')
        .where('id-proveedor', isEqualTo: idUsuario)
        .where("aceptado", isEqualTo: true)
        .where("terminado", isEqualTo: false)
        .where("canceladoProveedor", isEqualTo: false)
        .where("canceladoCliente", isEqualTo: false)
        .orderBy("fechaInicio", descending: true)
        .snapshots();
  }

  loadSolicitud(String coleccion, Solicitud datasolicitud) async {
    await Firestore.instance.collection(coleccion).add({
      'aceptado': datasolicitud.aceptado,
      'revisado': datasolicitud.revisado,
      'descripcion': datasolicitud.descripcion,
      'direccion': datasolicitud.direccion,
      'fechaSolicitud': datasolicitud.fechaSolicitud,
      'fechaFin': datasolicitud.fechaFin,
      'fechaInicio': datasolicitud.fechaInicio,
      'id-cliente': datasolicitud.idCliente,
      'id-proveedor': datasolicitud.idProveedor,
      'id-servicio': datasolicitud.idServicio,
      'cliente': datasolicitud.cliente,
      'proveedor': datasolicitud.proveedor,
      'servicio': datasolicitud.servicio,
      'terminado': datasolicitud.terminado,
      'canceladoCliente': datasolicitud.canceladoCliente,
      'canceladoProveedor': datasolicitud.canceladoProveedor,
      'puntuacionPendiente': datasolicitud.puntuacionPendiente,
      'puntuado': datasolicitud.puntuado,
      'razonCancelacion': datasolicitud.razonCancelacion,
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

  aceptarSolicitud(idSolicitud, String servicio, String id) async {
    await Firestore.instance.document("solicitudes/" + idSolicitud).updateData({
      "aceptado": true,
      "revisado": true,
      "fechaInicio": Timestamp.fromDate(DateTime.now())
    }).then((value) => print("Solicitud Aceptada"));
    final cliente = await usuarioProvider.getUserToken(id);
    pushProvider.sendNotifications(
        'Tu solicitud para el servicio $servicio ha sido aceptada',
        'Solicitud Aceptada',
        null,
        cliente.data['token_dispositivo']);
  }

  rechazarSolicitud(idSolicitud, String servicio, String id) async {
    await Firestore.instance
        .document("solicitudes/" + idSolicitud)
        .updateData({"aceptado": false, "revisado": true}).then(
            (value) => print("Solicitud Rechazada"));
    final cliente = await usuarioProvider.getUserToken(id);
    pushProvider.sendNotifications(
        'Tu solicitud para el servicio $servicio ha sido rechazada',
        'Solicitud Rechazada',
        null,
        cliente.data['token_dispositivo']);
  }

  finalizarSolicitud(idSolicitud, String servicio, String id) async {
    await Firestore.instance.document("solicitudes/" + idSolicitud).updateData({
      "terminado": true,
      "fechaFin": Timestamp.fromDate(DateTime.now())
    }).then((value) => print("Solicitud Aceptada"));
    final cliente = await usuarioProvider.getUserToken(id);
    pushProvider.sendNotifications(
        'Tu solicitud para el servicio $servicio ha finalizado',
        'Puntuar el servicio',
        null,
        cliente.data['token_dispositivo']);
  }

  cancelarSolicitud(idSolicitud, proveedor, razonCancelacion, String servicio,
      String id) async {
    await Firestore.instance.document("solicitudes/" + idSolicitud).updateData({
      proveedor ? "canceladoProveedor" : "canceladoCliente": true,
      "razonCancelacion": razonCancelacion,
    }).then((value) => print("Solicitud Cancelada"));
    String _mensaje = '';
    if (proveedor) {
      _mensaje = 'Tu solicitud para el servicio $servicio ha sido cancelada';
    } else {
      _mensaje = 'La solicitud para tu servicio $servicio ha sido cancelada';
    }
    final cliente = await usuarioProvider.getUserToken(id);
    pushProvider.sendNotifications(_mensaje, 'Solicitud Cancelada', null,
        cliente.data['token_dispositivo']);
  }

  Future<bool> updatePuntuacionPendiente(
      Map<String, dynamic> datos, String id) async {
    await Firestore.instance
        .collection('solicitudes')
        .document(id)
        .updateData(datos);
    return true;
  }
}
