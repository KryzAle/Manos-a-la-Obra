import 'dart:async';

import 'package:manos_a_la_obra/src/models/categoria_servicio_model.dart';
import 'package:manos_a_la_obra/src/providers/categoria_servicio_provider.dart';
import 'package:rxdart/rxdart.dart';

class CategoriaBloc {
  final categoriaProvider = CategoriasServiciosProviders();
  final _categoriaController = BehaviorSubject<List<CategoriaServicio>>();

  //escuchar stream
  Stream<List<CategoriaServicio>> get getCategoria =>
      _categoriaController.stream;

  //agregar stream
  Function(List<CategoriaServicio>) get changeCategoria =>
      _categoriaController.sink.add;

  void dispose() {
    _categoriaController?.close();
    print("cerrando esta");
  }

  void cargarCategoria() {
    final subscriptionCategoria = categoriaProvider.getCategorias();
    subscriptionCategoria.listen((event) {
      final categorias = new CategoriasServicios.fromJsonList(event.documents);
    _categoriaController.sink.add(categorias.items);
    });
  }
}
