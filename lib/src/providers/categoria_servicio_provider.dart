import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:manos_a_la_obra/src/models/categoria_servicio_model.dart';

class CategoriasServiciosProviders{

  Future<List<CategoriaServicio>> getCategorias() async{
    final snapshot = await Firestore.instance.collection('categoria-servicio').getDocuments();
    final categorias = new CategoriasServicios.fromJsonList(snapshot.documents);
    return categorias.items;
  }

}