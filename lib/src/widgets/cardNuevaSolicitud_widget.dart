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
        descripcion: pedido.descripcion,
        estado: pedido.aceptado,
        fechaInicio: pedido.fechaInicio,
        image: pedido.servicio["evidencia"],
        nombreServicio: pedido.servicio["nombre"],
        nombreCliente: pedido.nombreCliente,
        fotoCliente: pedido.fotoCliente,
      );
      widgets.add(card);
    }

    return widgets;
  }
}
