import 'package:flutter/material.dart';
import 'package:manos_a_la_obra/src/models/categoria_servicio_model.dart';

class DropdownMaker extends StatefulWidget {
  final List<CategoriaServicio> lista;
  DropdownMaker({Key key, @required this.lista}) : super(key: key);

  @override
  _DropdownMakerState createState() => _DropdownMakerState();
}

class _DropdownMakerState extends State<DropdownMaker> {
  String _selectedLocation;
  String holder = '';
  void getDropDownItem() {
    setState(() {
      holder = _selectedLocation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      hint: Text('Seleccionar..'),
      value: _selectedLocation,
      onChanged: (newValue) {
        setState(() {
          _selectedLocation = newValue;
          print(_selectedLocation);
        });
      },
      items: crearLista().map((location) {
        return DropdownMenuItem(
          child: new Text(location),
          value: location,
        );
      }).toList(),
    );
  }

  List<String> crearLista() {
    final List<String> items = List();
    for (var categoria in widget.lista) {
      items.add(categoria.nombre);
    }
    return items;
  }
}
