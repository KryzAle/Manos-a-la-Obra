import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:manos_a_la_obra/src/providers/servicio_provider.dart';
import 'package:manos_a_la_obra/src/providers/solicitud_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class TarjetaPedidosWidget extends StatefulWidget {
  final idDoc;
  final descripcion;
  final revisado;
  final aceptado;
  final fechaInicio;
  final image;
  final nombreServicio;
  TarjetaPedidosWidget({
    Key key,
    @required this.idDoc,
    @required this.descripcion,
    @required this.revisado,
    @required this.aceptado,
    @required this.fechaInicio,
    @required this.image,
    @required this.nombreServicio,
  }) : super(key: key);

  @override
  _TarjetaPedidosWidgetState createState() => _TarjetaPedidosWidgetState();
}

class _TarjetaPedidosWidgetState extends State<TarjetaPedidosWidget> {
  final providerServicio = SolicitudDataProvider();
  String imgUrl;

  @override
  Widget build(BuildContext context) {
    _obtenerUrlImagen(widget.image);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          //callback();
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            boxShadow: <BoxShadow>[
              widget.revisado
                  ? BoxShadow(
                      color: widget.aceptado
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
                                      widget.nombreServicio,
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
                                          widget.revisado
                                              ? widget.aceptado
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
                                                      color: Colors.yellow),
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
                                      .format(widget.fechaInicio.toDate(),
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
                                  content: Text("La solicitud no se completó"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('Cancelar la solicitud'),
                                      onPressed: () {
                                        providerServicio.cancelarSolicitud(
                                            widget.idDoc, false);
                                        Navigator.of(context).pop();
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
    final fileURL = await providerServicio.getImageServicio(widget.image);
    if (this.mounted) {
      setState(() {
        imgUrl = fileURL;
      });
    }
  }
}
