

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:manos_a_la_obra/src/bloc/validators.dart';
import 'package:manos_a_la_obra/src/providers/usuario_provider.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators{
  final _usuarioProvider = new UsuarioProvider();
  final _passwordController = BehaviorSubject<String>();
  final _nombreController = BehaviorSubject<String>();
  final _cedulaController = BehaviorSubject<String>();
  final _emailController    = BehaviorSubject<String>();
  final _cargandoController = StreamController<bool>.broadcast();

  //Insertar valores al Stream
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeNombre => _nombreController.sink.add;
  Function(String) get changeCedula => _cedulaController.sink.add;
  Function(bool) get changeCargando => _cargandoController.sink.add;

  //Recurar valores del Stream
  Stream<String> get emailStream => _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream => _passwordController.stream.transform(validarPassword);
  Stream<String> get cedulaStream => _cedulaController.stream.transform(validarCedula);
  Stream<String> get nombreStream => _nombreController.stream.transform(validarCampo);
  Stream<bool> get cargandoStream => _cargandoController.stream;

  
  // obtenr ultimo valor ingresado
  String get email => _emailController.value;
  String get nombre => _nombreController.value;
  String get cedula => _cedulaController.value;
  String get password => _passwordController.value;

  Future<bool> login()async{
    try {
      return await _usuarioProvider.signInWithCredentials(email, password);  
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> isLogin() async{
    return await _usuarioProvider.isSignedIn();
  }
  Future<bool> register() async{
    try {
      return await _usuarioProvider.signUp(email,password,nombre,cedula);
    } catch (e) {
      return Future.error(e);
    }
  }

  void logOut() {
    _usuarioProvider.signOut();
  }
  void cargando(bool cargar){
    changeCargando(cargar);
  }
  Future<FirebaseUser>  loginWithGoogle() async{
    return await _usuarioProvider.signInWithGoogle();
  }

  //Cerrar streams
  void dispose(){
    _emailController?.close();
    _passwordController?.close();
    _cargandoController?.close();
    _nombreController?.close();
    _cedulaController?.close();
  }
  Future<bool> cambiarPassword(String oldPassword){
    return _usuarioProvider.updatePassword(password,oldPassword);
  }
  void resetValues(){
    _emailController.value='';
    _passwordController.value ='';
    _nombreController.value ='';
    _cedulaController.value ='';
  }
}