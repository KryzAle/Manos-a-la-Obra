

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:manos_a_la_obra/src/bloc/validators.dart';
import 'package:manos_a_la_obra/src/providers/usuario_provider.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators{
  final _usuarioProvider = new UsuarioProvider();
  final _passwordController = BehaviorSubject<String>();
  final _emailController    = BehaviorSubject<String>();

  //Insertar valores al Stream
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  //Recurar valores del Stream
  Stream<String> get emailStream => _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream => _passwordController.stream.transform(validarPassword);

  Stream<bool> get formValidStream => 
      Rx.combineLatest2(emailStream,passwordStream,(e,p) => true);

  // obtenr ultimo valor ingresado
  String get email => _emailController.value;
  String get password => _passwordController.value;
  
  void restarValues(){
    _passwordController.value='';
    _emailController.value='';
  }

  Future<bool> login() async{
    return await _usuarioProvider.signInWithCredentials(email, password);
  }

  Future<bool> isLogin() async{
    return await _usuarioProvider.isSignedIn();
  }
  Future<bool> register() async{
    return await _usuarioProvider.signUp(email,password);
  }

  void logOut() {
    _usuarioProvider.signOut();
  }


  Future<FirebaseUser>  loginWithGoogle() async{
    return await _usuarioProvider.signInWithGoogle();
  }

  //Cerrar streams
  void dispose(){
    _emailController?.close();
    _passwordController?.close();
  }
}