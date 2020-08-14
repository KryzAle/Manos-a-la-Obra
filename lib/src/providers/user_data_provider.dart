import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserDataProvider {
  final databaseReference = Firestore.instance;

  Future<Stream<DocumentSnapshot>> getUserDoc() async {
    final Firestore _firestore = Firestore.instance;
    final userId = await getIdCurrentUser();
    return _firestore.collection('usuario').document(userId).snapshots();
  }

  Future<bool> updateUserDoc(Map<String, dynamic> datos) async {
    final userId = await getIdCurrentUser();
    await databaseReference
        .collection('usuario')
        .document(userId)
        .updateData(datos);
    return true;
  }

  Future<String> getIdCurrentUser() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser user = await _auth.currentUser();
    return user.uid;
  }

  Future<void> saveImageUser(
    File data,
  ) async {
    if (data != null) {
      final id = await getIdCurrentUser();
      final imagePath = '/users/$id.jpg';
      final StorageReference storageReference =
          FirebaseStorage().ref().child(imagePath);

      final StorageUploadTask uploadTask = storageReference.putFile(data);

      final StreamSubscription<StorageTaskEvent> streamSubscription =
          uploadTask.events.listen((event) {
        print('EVENT ${event.type}');
      });

      await uploadTask.onComplete;
      streamSubscription.cancel();
      databaseReference
          .collection('usuario')
          .document(id)
          .updateData({'foto': imagePath});
    }
  }

  Future<String> getImageUsuario(String foto) async {
    try {
      final url = await FirebaseStorage().ref().child(foto).getDownloadURL();
      return url;
    } catch (e) {
      return null;
    }
  }
}
