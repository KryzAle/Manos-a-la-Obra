import 'dart:async';

import 'package:manos_a_la_obra/src/models/usuario_model.dart';
import 'package:manos_a_la_obra/src/providers/user_data_provider.dart';
import 'package:manos_a_la_obra/src/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';

class UsuarioBloc with Validators{
  final usuarioProvider = UserDataProvider();
  final _usuarioController = BehaviorSubject<Usuario>();
  final _telefonoController = BehaviorSubject<String>();
  final _nombreController = BehaviorSubject<String>();
  final _updateProgressController = BehaviorSubject<bool>();

  //escuchar stream
  Stream<Usuario> get getUsuario => _usuarioController.stream;
  Stream<String> get getNombre => _nombreController.stream;
  Stream<bool> get getUpdateProgress => _updateProgressController.stream;
  Stream<String> get getTelefono => _telefonoController.stream.transform(validarTelefono);

  //agregar stream
  Function(Usuario) get cambiarUsuario => _usuarioController.sink.add;
  Function(String) get cambiarNombre => _nombreController.sink.add;
  Function(String) get cambiarTelefono => _telefonoController.sink.add;
  Function(bool) get cambiarUpdateProgress => _updateProgressController.sink.add;

  void dispose() {
    _usuarioController?.close();
    _telefonoController?.close();
    _nombreController?.close();
    _updateProgressController?.close();
  }

  void cargarUsuario() {
    Usuario usuario;
    usuarioProvider.getUserDoc().then((value) {
      value.listen((event) {
        usuario = new Usuario.fromMap(event.data);
        cambiarUsuario(usuario);
      });
    });
  }
  
  Future<void> actualizarUsuario() async{
    Map<String,dynamic> _datos = {
      'nombre' : _nombreController.value,
      'telefono' : _telefonoController.value
    };
    cambiarUpdateProgress(await usuarioProvider.updateUserDoc(_datos));
  }
  

  void logout(){
    _usuarioController.value = null;
  }
}
