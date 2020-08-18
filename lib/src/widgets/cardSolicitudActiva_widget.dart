import 'package:flutter/material.dart';
import 'package:manos_a_la_obra/src/models/solicitud_model.dart';
import 'package:manos_a_la_obra/src/widgets/tarjeta_solicitud_activa_widget.dart';

class CardSolicitudActiva extends StatelessWidget {
  final List<Solicitud> lista;
  CardSolicitudActiva({@required this.lista});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: _crearCardSolicitudActiva(),
    );
  }

  List<Widget> _crearCardSolicitudActiva() {
    final List<Widget> widgets = List();
    for (var pedido in lista) {
      final card = TarjetaSolicitudActivaWidget(
        idSolicitudDoc: pedido.id,
        descripcion: pedido.descripcion,
        estado: pedido.aceptado,
        fechaInicio: pedido.fechaInicio,
        image: pedido.servicio["evidencia"],
        nombreServicio: pedido.servicio["nombre"],
        nombreCliente: pedido.cliente["nombre"],
        fotoCliente: pedido.cliente["foto"],
      );
      widgets.add(card);
    }

    return widgets;
  }
}
