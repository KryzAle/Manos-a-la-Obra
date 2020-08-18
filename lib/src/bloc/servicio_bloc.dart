import 'dart:async';
import 'dart:io';

import 'package:manos_a_la_obra/src/models/servicio_model.dart';
import 'package:manos_a_la_obra/src/providers/servicio_provider.dart';
import 'package:manos_a_la_obra/src/providers/user_data_provider.dart';
import 'package:manos_a_la_obra/src/providers/usuario_provider.dart';
import 'package:rxdart/rxdart.dart';

class ServicioBloc {
  final puntuacionProvider = new UsuarioProvider();
  final usuarioProvider = new UserDataProvider();
  final servicioProvider = ServicioDataProvider();
  final _serviciosController = BehaviorSubject<List<Servicio>>();
  final _serviciosUsuarioController = BehaviorSubject<List<Servicio>>();

  //escuchar stream
  Stream<List<Servicio>> get getServicios => _serviciosController.stream;
  Stream<List<Servicio>> get getServiciosUsuario =>
      _serviciosUsuarioController.stream;

  //agregar stream
  Function(List<Servicio>) get changeServicio => _serviciosController.sink.add;
  Function(List<Servicio>) get changeServicioUsuario =>
      _serviciosUsuarioController.sink.add;

  void dispose() {
    _serviciosController?.close();
    _serviciosUsuarioController?.close();
  }

  void cargarServicios() {
    final subscriptionServicio = servicioProvider.getServicios();
    subscriptionServicio.listen((event) async {
      final servicios = new List<Servicio>();
      for (var item in event.documents) {
        final servicio = Servicio.fromJsonMap(item.data, item.documentID);
        servicio.puntaje = 3.0;
        servicios.add(servicio);
      }
      changeServicio(servicios);
    });
  }

  void cargarServiciosUsuario() {
    usuarioProvider.getIdCurrentUser().then((value) {
      final subscriptionServicio = servicioProvider.getServiciosUsuario(value);
      subscriptionServicio.listen((event) {
        final servicios = new List<Servicio>();
        for (var item in event.documents) {
          final servicio = Servicio.fromJsonMap(item.data, item.documentID);
          servicios.add(servicio);
        }
        changeServicioUsuario(servicios);
      });
    });
  }

  Future<void> insertarServicio(
      Servicio dataservicio, String idUsuario, List<File> imagenes) async {
    final listaPaths = List();
    for (var imagen in imagenes) {
      final path = await servicioProvider.guardarImageServicio(imagen);
      listaPaths.add(path);
    }
    dataservicio.evidencia = listaPaths;
    await servicioProvider.loadServicio("servicio", dataservicio, idUsuario);
  }
}
