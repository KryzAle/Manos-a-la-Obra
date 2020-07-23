import 'package:flutter/material.dart';
import 'package:manos_a_la_obra/src/models/servicio_model.dart';
import 'package:manos_a_la_obra/src/widgets/tarjeta_widget.dart';

class CardServicio extends StatelessWidget {
  final List<Servicio> lista;
  CardServicio({@required this.lista});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: _crearCardServicio(),
    );
  }

  List<Widget> _crearCardServicio() {
    final List<Widget> widgets = List();
    for (var servicio in lista) {
      final card = TarjetaWidget(
        id: servicio.id,
        categoria: servicio.categoria,
        descripcion: servicio.descripcion,
        nombre: servicio.nombre,
        path: servicio.evidencia[0],
      );
      widgets.add(card);
    }

    return widgets;
  }
}
