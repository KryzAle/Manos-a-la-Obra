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
        solicitud: pedido,
      );
      widgets.add(card);
    }

    return widgets;
  }
}
