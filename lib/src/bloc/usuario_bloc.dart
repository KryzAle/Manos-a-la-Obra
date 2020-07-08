import 'dart:async';

import 'package:manos_a_la_obra/src/models/usuario_model.dart';
import 'package:manos_a_la_obra/src/providers/user_data_provider.dart';

class UsuarioBloc {
  final usuarioProvider = UserDataProvider();
  final _usuarioController = StreamController<Usuario>.broadcast();

  //escuchar stream
  Stream<Usuario> get getUsuario => _usuarioController.stream;

  //agregar stream
  Function(Usuario) get cambiarUsuario => _usuarioController.sink.add;

  void dispose() {
    _usuarioController?.close();
  }

  void cargarUsuario() async {
    cambiarUsuario(await usuarioProvider.getUserDoc());
  }
}
