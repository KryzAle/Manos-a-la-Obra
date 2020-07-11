
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataProvider {
  final databaseReference = Firestore.instance;

  Future<Stream<DocumentSnapshot>> getUserDoc() async {
    final Firestore _firestore = Firestore.instance;
    final userId = await getIdCurrentUser();
    return _firestore.collection('usuario').document(userId).snapshots();
  }

  Future<bool> updateUserDoc(Map<String,dynamic> datos) async{
    final userId = await getIdCurrentUser();
    await databaseReference.collection('usuario').document(userId).updateData(datos);
    return true;
  }

  Future<String> getIdCurrentUser() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser user = await _auth.currentUser();
    return user.uid;
  }
}
