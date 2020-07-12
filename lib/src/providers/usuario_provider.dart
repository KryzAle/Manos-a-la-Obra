import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:manos_a_la_obra/src/models/puntuacion_model.dart';

class UsuarioProvider {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<bool> signInWithCredentials(String email, String password) async{
    bool login = false;
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      login =true;
    } catch (e) {
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
          'celular' : '',
        }
      );
      register =true;
    } catch (e) {
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

  Future<bool> updatePassword(String password) async {
    bool update = false;
    try {
      final usuario = await user();
      await usuario.updatePassword(password);
      update = true;
    } catch (e) {
      print(e);
    }
    return update;
  }
}