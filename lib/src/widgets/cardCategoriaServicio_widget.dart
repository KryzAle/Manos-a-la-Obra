import 'package:flutter/material.dart';
import 'package:manos_a_la_obra/src/models/categoria_servicio_model.dart';
import 'package:manos_a_la_obra/src/utils/color_util.dart';
import 'package:manos_a_la_obra/src/utils/icon_util.dart';
import 'package:manos_a_la_obra/src/widgets/botonCircle_widget.dart';

class CardCateriaServicio extends StatelessWidget {
  final List<CategoriaServicio> lista;
  CardCateriaServicio({@required this.lista});
  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Wrap(
            spacing: 20.0,
            runSpacing: 50.0,
            alignment: WrapAlignment.center,
            children: _crearCards(),
          ),
        ],
      ),
    );
  }

  List<Widget> _crearCards() {
    final List<Widget> widgets = List();
    for (var categoria in lista) {
      final card = ButtonCircle(
        icon: getIcon(categoria.icon),
        texto: categoria.nombre,
        color: getColor(categoria.color)
      );
      widgets.add(card);

      
    }
    return widgets;
  }
}