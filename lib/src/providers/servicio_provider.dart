import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:manos_a_la_obra/src/models/servicio_model.dart';

class ServicioDataProvider {
  Stream<QuerySnapshot> getServicios() {
    return Firestore.instance.collection('servicio').snapshots();
  }

  Stream<QuerySnapshot> getServiciosUsuario(String idUsuario) {
    print(idUsuario);
    return Firestore.instance
        .collection('servicio')
        .where('id-usuario', isEqualTo: idUsuario)
        .snapshots();
  }

  loadServicio(
      String coleccion, Servicio dataservicio, String idUsuario) async {
    await Firestore.instance.collection(coleccion).add({
      'categoria': dataservicio.categoria,
      'disponibilidad': dataservicio.disponibilidad,
      'evidencia': dataservicio.evidencia,
      'id-usuario': dataservicio.idUsuario,
      'nombre': dataservicio.nombre,
      'descripcion': dataservicio.descripcion,
    });
    Firestore.instance.document("usuario/" + idUsuario).updateData(
        {"proveedor": true}).then((value) => print("Inscrito como proveedor"));
  }

  getImageServicio(path) async {
    StorageReference ref = FirebaseStorage.instance.ref().child(path);
    String fileURL = await ref.getDownloadURL();
    return fileURL;
  }
}
