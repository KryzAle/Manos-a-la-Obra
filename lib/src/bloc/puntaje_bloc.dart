import 'dart:async';

import 'package:manos_a_la_obra/src/providers/usuario_provider.dart';

class PuntajeBloc{
  final puntuacionProvider = UsuarioProvider();

  Future<double> getPromPuntajeUsuario(String idUsuario)async{
    final puntuaciones = await puntuacionProvider.puntaje(idUsuario);
    double puntaje = 0;
    if(puntuaciones!=null){
      for (var puntuacion in puntuaciones) {
        puntaje += puntuacion.valor;
      }
      puntaje /= puntuaciones.length;
    }
    return puntaje;
  }
}