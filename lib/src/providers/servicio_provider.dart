
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:manos_a_la_obra/src/models/servicio_model.dart';

class ServicioDataProvider {
  
  Stream<QuerySnapshot> getServicios() {
    return Firestore.instance.collection('servicio').snapshots();
  }

  Stream<QuerySnapshot> getServiciosUsuario(String idUsuario) {

    return Firestore.instance.collection('servicio').where('id-usuario',isEqualTo: idUsuario).snapshots();
  }

  loadServicio(String coleccion, Servicio dataservicio) async {
    await Firestore.instance.collection(coleccion).add({
      'categoria': dataservicio.categoria,
      'disponibilidad': dataservicio.disponibilidad,
      'evidencia': dataservicio.evidencia,
      'id-usuario': dataservicio.idUsuario,
      'nombre': dataservicio.nombre,
      'descripcion': dataservicio.descripcion,
    });
  }
}
