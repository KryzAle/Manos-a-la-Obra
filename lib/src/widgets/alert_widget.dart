import 'package:flutter/material.dart';

class AlertSolicitudes extends StatelessWidget {
  const AlertSolicitudes({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text("¿Brindas algún servicio?"),
      content: new Text("¿Quieres ser parte de Manos a la Obra?"),
      actions: <Widget>[
        new FlatButton(
          child: new Text("Registrar un servicio"),
          onPressed: () {
            Navigator.pushNamed(context, 'register_solicitudes');
          },
        ),
      ],
    );
  }
}
