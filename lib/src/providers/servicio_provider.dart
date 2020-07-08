import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:manos_a_la_obra/src/models/servicio_model.dart';

class ServicioDataProvider {
  Future<List<Servicio>> getServicios() async {
    final snapshot =
        await Firestore.instance.collection('servicio').getDocuments();
    final servicios = new Servicios.fromList(snapshot.documents);
    return servicios.items;
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
