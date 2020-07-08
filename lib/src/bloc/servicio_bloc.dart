import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:manos_a_la_obra/src/models/servicio_model.dart';
import 'package:manos_a_la_obra/src/providers/servicio_provider.dart';
import 'package:manos_a_la_obra/src/providers/user_data_provider.dart';

class ServicioBloc {
  final servicioProvider = ServicioDataProvider();
  final _servicioController = StreamController<List<Servicio>>.broadcast();

  //escuchar stream
  Stream<List<Servicio>> get getServicio => _servicioController.stream;

  //agregar stream
  Function(List<Servicio>) get cambiarServicio => _servicioController.sink.add;

  void dispose() {
    _servicioController?.close();
  }

  void cargarServicio() async {
    final datosServicio = await servicioProvider.getServicios();
    _servicioController.sink.add(datosServicio);
  }

  void insertarServicio(Servicio dataservicio) async {
    await servicioProvider.loadServicio("servicio", dataservicio);
  }
}
