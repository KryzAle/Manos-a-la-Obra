import 'package:flutter/material.dart';
import 'package:manos_a_la_obra/src/bloc/provider.dart';
import 'package:manos_a_la_obra/src/models/usuario_model.dart';
import 'package:manos_a_la_obra/src/widgets/alert_widget.dart';

class SolicitudesPage extends StatefulWidget {
  SolicitudesPage({Key key}) : super(key: key);

  @override
  _SolicitudesPageState createState() => _SolicitudesPageState();
}

class _SolicitudesPageState extends State<SolicitudesPage> {
  @override
  Widget build(BuildContext context) {
    final userbloc = Provider.usuario(context);
    return StreamBuilder(
      stream: userbloc.getUsuario,
      builder: (BuildContext context, AsyncSnapshot<Usuario> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.proveedor) {
            return Center(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 75,
                      width: 50,
                    ),
                    ButtonTheme(
                      minWidth: 250.0,
                      height: 80.0,
                      child: RaisedButton(
                        color: Colors.greenAccent,
                        onPressed: () => print("Button Pressed"),
                        child: new Text(
                          "Nuevas Solicitudes",
                          style: TextStyle(fontSize: 20.5),
                        ),
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: 50,
                    ),
                    ButtonTheme(
                      minWidth: 250.0,
                      height: 80.0,
                      child: RaisedButton(
                        color: Colors.greenAccent,
                        onPressed: () => print("Button Pressed"),
                        child: new Text(
                          "Mis Solicitudes",
                          style: TextStyle(fontSize: 20.5),
                        ),
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: 50,
                    ),
                    ButtonTheme(
                      minWidth: 250.0,
                      height: 80.0,
                      child: RaisedButton(
                        color: Colors.greenAccent,
                        onPressed: () => print("Button Pressed"),
                        child: new Text(
                          "Mis Servicios",
                          style: TextStyle(fontSize: 20.5),
                        ),
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return AlertSolicitudes();
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
