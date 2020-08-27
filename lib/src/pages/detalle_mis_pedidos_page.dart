import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manos_a_la_obra/src/models/solicitud_model.dart';
import 'package:manos_a_la_obra/src/pages/item_descripcion.dart';
import 'package:manos_a_la_obra/src/providers/solicitud_provider.dart';
import 'package:manos_a_la_obra/src/widgets/item_header_solicitud.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class DetalleMisPedidosPage extends StatefulWidget {
  DetalleMisPedidosPage(this.solicitud, {Key key}) : super(key: key);

  final Solicitud solicitud;

  @override
  _DetalleSolicitudPageState createState() => _DetalleSolicitudPageState();
}

class _DetalleSolicitudPageState extends State<DetalleMisPedidosPage> {
  final providerSolicitud = SolicitudDataProvider();

  String razonCancelacion;
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.hardEdge,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SolicitudDetalleHeader(widget.solicitud, true),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
              child: SizedBox(
                width: double.infinity,
                // height: double.infinity,

                child: !widget.solicitud.puntuado&widget.solicitud.terminado
                    ? RaisedButton(
                        onPressed: () => {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    title: Text(
                                        "Puntue su experiencia con el servicio"),
                                    content: Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Row(
                                        children: <Widget>[
                                          SmoothStarRating(
                                            allowHalfRating: true,
                                            starCount: 5,
                                            rating: 4.5,
                                            size: 50,
                                            color: Colors.orange,
                                            borderColor: Colors.yellow,
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Aceptar'),
                                        onPressed: () {},
                                      ),
                                      FlatButton(
                                        child: Text('Cancelar'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ]);
                              })
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Icon(
                                Icons.star,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Puntuar Servicio",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        padding: const EdgeInsets.all(12),
                        color: Colors.orange,
                        highlightColor: Colors.orange.shade400,
                        splashColor: Colors.orange.shade400,
                        elevation: 8,
                        highlightElevation: 10,
                      )
                    : SizedBox(width: 10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: SizedBox(
                width: double.infinity,
                child: !widget.solicitud.terminado 
                ? OutlineButton(
                  onPressed: () => {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: Text("¿Esta seguro?"),
                              content: Form(
                                key: formkey,
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  padding: EdgeInsets.only(bottom: 10.0),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      labelText:
                                          "Escriba la razón de la cancelación",
                                      labelStyle: TextStyle(
                                          color: Colors.black87, fontSize: 13),
                                      hintText:
                                          "Ejemplo: No puedo pagar por el servicio",
                                      hintStyle: TextStyle(fontSize: 12.0),
                                      border: OutlineInputBorder(),
                                    ),
                                    initialValue: razonCancelacion,
                                    maxLines: 5,
                                    onSaved: (value) {
                                      razonCancelacion = value;
                                    },
                                    validator: (value) {
                                      if (value.length < 10) {
                                        return 'Debe ser mayor a 10 caracteres ';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Cancelar la solicitud'),
                                  onPressed: () {
                                    _submit(context);
                                  },
                                ),
                                FlatButton(
                                  child: Text('Atrás'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ]);
                        })
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                      ),
                      Text(
                        "Cancelar Solicitud",
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  padding: const EdgeInsets.all(12),
                  borderSide: BorderSide(color: Colors.red[200], width: 4),
                  color: Colors.white,
                  highlightColor: Colors.white70,
                  splashColor: Colors.red.shade200,
                  highlightElevation: 0,
                  highlightedBorderColor: Colors.red.shade400,
                )
                : Container(),
              ),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: Column(
                  children: [
                    DescriptionText("Servicio que solicita",
                        widget.solicitud.servicio["nombre"]),
                    DescriptionText("Descripcion del Servicio",
                        widget.solicitud.descripcion),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  void _submit(BuildContext context) {
    if (!formkey.currentState.validate()) return;
    formkey.currentState.save();

    providerSolicitud.cancelarSolicitud(
        widget.solicitud.id, true, razonCancelacion);
    Navigator.of(context).pop();
  }
}
