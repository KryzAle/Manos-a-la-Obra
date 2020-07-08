import 'dart:async';

import 'package:manos_a_la_obra/src/models/servicio_model.dart';
import 'package:manos_a_la_obra/src/providers/servicio_provider.dart';
import 'package:manos_a_la_obra/src/providers/usuario_provider.dart';
import 'package:rxdart/rxdart.dart';


class ServicioBloc{
  final servicios = new List<Servicio>();
  final puntuacionProvider = new UsuarioProvider();
  final servicioProvider = ServicioDataProvider();
  final _serviciosController = BehaviorSubject<List<Servicio>>();

  //escuchar stream
  Stream<List<Servicio>> get getServicios => _serviciosController.stream;
  
  //agregar stream
  Function(List<Servicio>) get changeServicio => _serviciosController.sink.add;

  void dispose(){
    _serviciosController?.close();
  }

  void cargarServicios() {
    final subscriptionServicio = servicioProvider.getServicios();
    subscriptionServicio.listen((event) async {
      for (var item in event.documentChanges) {
        double puntaje = 0;
        final servicio = Servicio.fromJsonMap(item.document.data, item.document.documentID);
        final puntuaciones = await puntuacionProvider.puntaje(servicio.idUsuario);
        if(puntuaciones!=null){
          for (var puntuacion in puntuaciones) {
            puntaje += puntuacion.valor;
          }
          puntaje /= puntuaciones.length;
          servicio.puntaje = puntaje;
        }
        servicios.add(servicio);
      }
    });
    changeServicio(servicios);
  }
   void insertarServicio(Servicio dataservicio) async {
    await servicioProvider.loadServicio("servicio", dataservicio);
  }
  
}
