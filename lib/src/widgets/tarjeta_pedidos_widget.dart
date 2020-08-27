import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:manos_a_la_obra/src/models/solicitud_model.dart';
import 'package:manos_a_la_obra/src/pages/detalle_mis_pedidos_page.dart';
import 'package:manos_a_la_obra/src/providers/servicio_provider.dart';
import 'package:manos_a_la_obra/src/providers/solicitud_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class TarjetaPedidosWidget extends StatefulWidget {
  final Solicitud solicitud;
  /*final idDoc;
  final descripcion;
  final revisado;
  final aceptado;
  final fechaInicio;
  final image;
  final nombreServicio;*/
  TarjetaPedidosWidget({
    Key key,
    @required this.solicitud,
    /*@required this.idDoc,
    @required this.descripcion,
    @required this.revisado,
    @required this.aceptado,
    @required this.fechaInicio,
    @required this.image,
    @required this.nombreServicio,*/
  }) : super(key: key);

  @override
  _TarjetaPedidosWidgetState createState() => _TarjetaPedidosWidgetState();
}

class _TarjetaPedidosWidgetState extends State<TarjetaPedidosWidget> {
  final providerServicio = SolicitudDataProvider();
  String razonCancelacion;
  final formkey = GlobalKey<FormState>();

  String imgUrl;

  @override
  Widget build(BuildContext context) {
    _obtenerUrlImagen(widget.solicitud.servicio["evidencia"]);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          _irDetalleSolicitud(context, widget.solicitud);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            boxShadow: <BoxShadow>[
              widget.solicitud.revisado
                  ? BoxShadow(
                      color: widget.solicitud.aceptado
                          ? Colors.greenAccent.withOpacity(0.9)
                          : Colors.red.withOpacity(0.8),
                      offset: const Offset(4, 4),
                      blurRadius: 16,
                    )
                  : BoxShadow(
                      color: Colors.yellow.withOpacity(0.9),
                      offset: const Offset(4, 4),
                      blurRadius: 16,
                    ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 2,
                      child: imgUrl != null
                          ? Image.network(
                              imgUrl,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              child: CircularProgressIndicator(),
                              alignment: Alignment.center,
                            ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, top: 8, bottom: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      widget.solicitud.servicio["nombre"],
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Row(
                                        children: <Widget>[
                                          widget.solicitud.revisado
                                              ? widget.solicitud.aceptado
                                                  ? Text(
                                                      "Aceptado",
                                                      style: TextStyle(
                                                          color: Colors.green),
                                                    )
                                                  : Text(
                                                      "Rechazado",
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    )
                                              : Text(
                                                  "Esperando Aprobación",
                                                  style: TextStyle(
                                                      color: Colors.orange),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16, top: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  timeago
                                      .format(
                                          widget.solicitud.fechaSolicitud
                                              .toDate(),
                                          locale: 'es')
                                      .toString(),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(32.0),
                    ),
                    child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: Text("¿Esta seguro?"),
                                  content: Form(
                                    key: formkey,
                                    child: Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      padding: EdgeInsets.only(bottom: 10.0),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          labelText:
                                              "Escriba la razón de la cancelación",
                                          labelStyle: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 13),
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
                            });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.not_interested,
                          color: Colors.deepOrange,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _obtenerUrlImagen(path) async {
    final providerServicio = ServicioDataProvider();
    final fileURL = await providerServicio.getImageServicio(path);
    if (this.mounted) {
      setState(() {
        imgUrl = fileURL;
      });
    }
  }

  void _irDetalleSolicitud(BuildContext context, Solicitud misolicitud) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (c) {
          return DetalleMisPedidosPage(misolicitud);
        },
      ),
    );
  }

  void _submit(BuildContext context) {
    if (!formkey.currentState.validate()) return;
    formkey.currentState.save();

    providerServicio.cancelarSolicitud(
        widget.solicitud.id, true, razonCancelacion);
    Navigator.of(context).pop();
  }
}
