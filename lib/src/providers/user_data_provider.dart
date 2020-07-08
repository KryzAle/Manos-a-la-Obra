import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:manos_a_la_obra/src/models/servicio_model.dart';
import 'package:manos_a_la_obra/src/models/usuario_model.dart';

class UserDataProvider {
  final databaseReference = Firestore.instance;

  Future<Usuario> getUserDoc() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;

    FirebaseUser user = await _auth.currentUser();
    final snapshot =
        await _firestore.collection('usuario').document(user.uid).get();
    final usuario = new Usuario.fromMap(snapshot.data);
    return usuario;
  }

  getIdCurrentUser() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    FirebaseUser user = await _auth.currentUser();
    return user.uid;
  }
}
