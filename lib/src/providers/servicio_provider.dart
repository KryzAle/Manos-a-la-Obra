import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:manos_a_la_obra/src/models/servicio_model.dart';

class ServicioDataProvider {
  Stream<QuerySnapshot> getServicios() {
    return Firestore.instance.collection('servicio').snapshots();
  }

  Stream<QuerySnapshot> getServiciosUsuario(String idUsuario) {
    return Firestore.instance
        .collection('servicio')
        .where('usuario.id', isEqualTo: idUsuario)
        .snapshots();
  }

  loadServicio(
      String coleccion, Servicio dataservicio, String idUsuario) async {
    await Firestore.instance.collection(coleccion).add({
      'categoria': dataservicio.categoria,
      'disponibilidad': dataservicio.disponibilidad,
      'evidencia': dataservicio.evidencia,
      'usuario': dataservicio.usuario,
      'nombre': dataservicio.nombre,
      'direccion': dataservicio.direccion,
      'descripcion': dataservicio.descripcion,
      'fechaCreacion': Timestamp.fromDate(DateTime.now()),
      'fechaModificacion': dataservicio.fechaModificacion,
      'popuparidad': dataservicio.popularidad,
      'valoracionTotal': dataservicio.valoracionTotal,
    });
    Firestore.instance.document("usuario/" + idUsuario).updateData(
        {"proveedor": true}).then((value) => print("Inscrito como proveedor"));
  }

  Future<String> guardarImageServicio(File file) async {
    if (file != null) {
      final imagePath = 'servicios/${DateTime.now()}.jpg';
      final StorageReference storageReference =
          FirebaseStorage().ref().child(imagePath);

      final StorageUploadTask uploadTask = storageReference.putFile(file);

      final StreamSubscription<StorageTaskEvent> streamSubscription =
          uploadTask.events.listen((event) {
        print('EVENT ${event.type}');
      });

      await uploadTask.onComplete;
      streamSubscription.cancel();
      return imagePath;
    } else
      return null;
  }

  getImageServicio(path) async {
    StorageReference ref = FirebaseStorage.instance.ref().child(path);
    String fileURL = await ref.getDownloadURL();
    return fileURL;
  }

  deleteServicio(idDocument) async {
    await Firestore.instance
        .collection("servicio")
        .document(idDocument)
        .delete();
  }
}
