import 'package:flutter/material.dart';
import 'package:manos_a_la_obra/src/models/solicitud_model.dart';
import 'package:manos_a_la_obra/src/widgets/tarjeta_nueva_solicitud_widget.dart';

class CardNuevaSolicitud extends StatelessWidget {
  final List<Solicitud> lista;
  CardNuevaSolicitud({@required this.lista});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: _crearCardNuevaSolicitud(),
    );
  }

  List<Widget> _crearCardNuevaSolicitud() {
    final List<Widget> widgets = List();
    for (var pedido in lista) {
      final card = TarjetaNuevaSolicitudWidget(
        solicitud: pedido,
      );
      widgets.add(card);
    }

    return widgets;
  }
}
