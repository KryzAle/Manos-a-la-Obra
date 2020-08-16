import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:manos_a_la_obra/src/models/puntuacion_model.dart';

class UsuarioProvider {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<bool> signInWithCredentials(String email, String password) async{
    bool login = false;
    String errorMessage;
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      login =true;
    } catch (e) {
      final error = e as PlatformException;
      switch (error.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Tu email no es valido.";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "Tu password es incorrecto.";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "No existe ese email registrado";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "Correo bloqueado";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Muchas peticiones. Intente mas tarde";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "El servicio esta suspendido.";
          break;
        default:
          errorMessage = "A ocurrido un error.";
      }
      if (errorMessage != null) {
        return Future.error(errorMessage);
      }
    }
    return login;
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }
  Future<FirebaseUser> user() async {
    return _firebaseAuth.currentUser();
  }
  // SignOut
  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }
  Future<FirebaseUser> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = 
        await googleUser.authentication;
      final AuthCredential credential =
        GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken
        );
      await _firebaseAuth.signInWithCredential(credential);
      return _firebaseAuth.currentUser();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  Future<bool> signUp(String email, String password, String nombre, String cedula) async{
    bool register = false;
    String errorMessage;
    try {
      final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password);
      await Firestore.instance.collection('usuario').document(user.user.uid).setData(
        {
          'foto'  : '',
          'nombre' : nombre,
          'cedula' : cedula,
          'proveedor' : false,
          'telefono' : '',
        }
      );
      register =true;
    } catch (e) {
      final error = e as PlatformException;
      print(error.code);
      switch (error.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
          errorMessage = "Ese correo ya esta en uso";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Muchas peticiones. Intente mas tarde";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "El servicio esta suspendido.";
          break;
        default:
          errorMessage = "A ocurrido un error.";
      }
      if (errorMessage != null) {
        return Future.error(errorMessage);
      }
    }
    return register;
  }
  Future<List<Puntuacion>> puntaje(String idUsuario) async{
    final snapshot = await Firestore.instance.collection('usuario').document(idUsuario).collection('puntuacion').getDocuments();
    if(snapshot.documents.isNotEmpty){
      final puntajes = new Puntuaciones.fromJsonList(snapshot.documents);
      return puntajes.items;
    }
    return null;
  }

  Future<bool> updatePassword(String password, String oldPassword) async {
    bool update = false;
    try {
      final usuario = await user();
      await usuario.reauthenticateWithCredential(EmailAuthProvider.getCredential(email: usuario.email,password: oldPassword));
      await usuario.updatePassword(password);
      update = true;
    } catch (e) {
      print(e);
    }
    return update;
  }
}