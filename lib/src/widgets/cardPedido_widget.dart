import 'package:flutter/material.dart';
import 'package:manos_a_la_obra/src/models/solicitud_model.dart';
import 'package:manos_a_la_obra/src/widgets/tarjeta_pedidos_widget.dart';

class CardPedido extends StatelessWidget {
  final List<Solicitud> lista;
  CardPedido({@required this.lista});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: _crearCardPedido(),
    );
  }

  List<Widget> _crearCardPedido() {
    final List<Widget> widgets = List();
    for (var pedido in lista) {
      final card = TarjetaPedidosWidget(
        idDoc: pedido.id,
        descripcion: pedido.descripcion,
        revisado: pedido.revisado,
        aceptado: pedido.aceptado,
        fechaInicio: pedido.fechaSolicitud,
        image: pedido.servicio["evidencia"],
        nombreServicio: pedido.servicio["nombre"],
      );
      widgets.add(card);
    }

    return widgets;
  }
}
