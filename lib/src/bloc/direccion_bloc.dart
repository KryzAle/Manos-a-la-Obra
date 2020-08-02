import 'dart:async';

import 'package:manos_a_la_obra/src/models/direccion_model.dart';
import 'package:manos_a_la_obra/src/providers/direccion_provider.dart';
import 'package:manos_a_la_obra/src/providers/user_data_provider.dart';
import 'package:rxdart/rxdart.dart';

class DireccionBloc {
  final usuarioProvider = new UserDataProvider();
  final direccionProvider = new DireccionProvider();
  final _direccionController = BehaviorSubject<List<Direccion>>();

  //escuchar stream
  Stream<List<Direccion>> get getDireccion => _direccionController.stream;

  //agregar stream
  Function(List<Direccion>) get changeDireccion => _direccionController.sink.add;

  void dispose() {
    _direccionController?.close();
  }

  void cargarDireccionUsuario() {
    usuarioProvider.getIdCurrentUser().then((value) {
      final subscriptionDireccion = direccionProvider.getDirecciones(value);
      subscriptionDireccion.listen((event) async {
        final direcciones = new List<Direccion>();
        for (var item in event.documents) {
          final direccion = Direccion.fromJsonMap(item.data, item.documentID);
          direcciones.add(direccion);
        }
        changeDireccion(direcciones);
      });
    });
  }

  
}
