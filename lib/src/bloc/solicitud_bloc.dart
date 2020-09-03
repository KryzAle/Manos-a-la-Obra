import 'dart:async';

import 'package:manos_a_la_obra/src/models/solicitud_model.dart';
import 'package:manos_a_la_obra/src/providers/push_notification_provider.dart';
import 'package:manos_a_la_obra/src/providers/solicitud_provider.dart';
import 'package:manos_a_la_obra/src/providers/user_data_provider.dart';
import 'package:manos_a_la_obra/src/providers/usuario_provider.dart';
import 'package:rxdart/rxdart.dart';

class SolicitudBloc {
  final pushProvider = PushNotificationProvider();
  final puntuacionProvider = new UsuarioProvider();
  final usuarioProvider = new UserDataProvider();
  final solicitudProvider = SolicitudDataProvider();
  final _solicitudesController = BehaviorSubject<List<Solicitud>>();
  final _solicitudesUsuarioController = BehaviorSubject<List<Solicitud>>();
  final _nuevasSolicitudesUsuarioController =
      BehaviorSubject<List<Solicitud>>();
  final _misSolicitudesActivasController = BehaviorSubject<List<Solicitud>>();

  //escuchar stream
  Stream<List<Solicitud>> get getSolicitudes => _solicitudesController.stream;
  Stream<List<Solicitud>> get getSolicitudesUsuario =>
      _solicitudesUsuarioController.stream;
  Stream<List<Solicitud>> get getNuevasSolicitudes =>
      _nuevasSolicitudesUsuarioController.stream;
  Stream<List<Solicitud>> get getMisSolicitudesActivas =>
      _misSolicitudesActivasController.stream;

  //agregar stream
  Function(List<Solicitud>) get changeSolicitud =>
      _solicitudesController.sink.add;
  Function(List<Solicitud>) get changeSolicitudUsuario =>
      _solicitudesUsuarioController.sink.add;
  Function(List<Solicitud>) get changeNuevaSolicitudUsuario =>
      _nuevasSolicitudesUsuarioController.sink.add;
  Function(List<Solicitud>) get changeMisSolicitudesActivas =>
      _misSolicitudesActivasController.sink.add;

  void dispose() {
    _solicitudesController?.close();
    _solicitudesUsuarioController?.close();
    _nuevasSolicitudesUsuarioController?.close();
    _misSolicitudesActivasController?.close();
  }

  void cargarSolicitudesUsuario() {
    usuarioProvider.getIdCurrentUser().then((value) {
      final subscriptionSolicitud =
          solicitudProvider.getSolicitudesUsuario(value);
      subscriptionSolicitud.listen((event) {
        final solicitudes = new List<Solicitud>();
        for (var item in event.documents) {
          final solicitud = Solicitud.fromJsonMap(item.data, item.documentID);
          solicitudes.add(solicitud);
        }
        changeSolicitudUsuario(solicitudes);
      });
    });
  }

  void cargarNuevasSolicitudesUsuario() {
    usuarioProvider.getIdCurrentUser().then((value) {
      final subscriptionSolicitud =
          solicitudProvider.getNuevasSolicitudes(value);
      subscriptionSolicitud.listen((event) {
        final solicitudes = new List<Solicitud>();
        for (var item in event.documents) {
          final solicitud = Solicitud.fromJsonMap(item.data, item.documentID);
          solicitudes.add(solicitud);
        }
        changeNuevaSolicitudUsuario(solicitudes);
      });
    });
  }

  void cargarMisSolicitudesActivas() {
    usuarioProvider.getIdCurrentUser().then((value) {
      final subscriptionSolicitud =
          solicitudProvider.getMisSolicitudesActivas(value);
      subscriptionSolicitud.listen((event) {
        final solicitudes = new List<Solicitud>();
        for (var item in event.documents) {
          final solicitud = Solicitud.fromJsonMap(item.data, item.documentID);
          solicitudes.add(solicitud);
        }
        changeMisSolicitudesActivas(solicitudes);
      });
    });
  }

  Future<void> insertarSolicitud(Solicitud datasolicitud,String token) async {
    await solicitudProvider.loadSolicitud("solicitudes", datasolicitud);
    pushProvider.sendNotifications('tienes una solicitud de ${datasolicitud.servicio['nombre']}', 'Nueva Solicitud', 'mis_nuevas_solicitudes', token);
  }
}
