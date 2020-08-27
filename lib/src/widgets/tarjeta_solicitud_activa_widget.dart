import 'package:flutter/material.dart';
import 'package:manos_a_la_obra/src/models/solicitud_model.dart';
import 'package:manos_a_la_obra/src/pages/detalle_nueva_solicitud_page.dart';
import 'package:manos_a_la_obra/src/pages/detalle_solicitud_activa_page.dart';
import 'package:manos_a_la_obra/src/providers/solicitud_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class TarjetaSolicitudActivaWidget extends StatefulWidget {
  final Solicitud solicitud;

  TarjetaSolicitudActivaWidget({
    Key key,
    @required this.solicitud,
  }) : super(key: key);

  @override
  _TarjetaSolicitudActivaWidgetState createState() =>
      _TarjetaSolicitudActivaWidgetState();
}

class _TarjetaSolicitudActivaWidgetState
    extends State<TarjetaSolicitudActivaWidget> {
  final providerSolicitud = SolicitudDataProvider();
  final formkey = GlobalKey<FormState>();
  String razonCancelacion;
  String imgUrl;

  @override
  Widget build(BuildContext context) {
    _obtenerUrlImagen(widget.solicitud.cliente["foto"]);
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
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
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
                                      widget.solicitud.cliente["nombre"],
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Flexible(
                                            child: new Text(
                                              widget
                                                  .solicitud.servicio["nombre"],
                                            ),
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
                                          widget.solicitud.fechaInicio.toDate(),
                                          locale: 'es')
                                      .toString(),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
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
                                              "Ejemplo: No puedo movilizarme a brindar el servicio",
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
                                            return 'Debe ser mayor a 10 caracteres';
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
                Positioned(
                  top: 130,
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
                                  title: Text("Finalizar esta Solicitud"),
                                  content:
                                      Text("¿La solicitud fue completada?"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('Solicitud Completada'),
                                      onPressed: () {
                                        providerSolicitud.finalizarSolicitud(
                                            widget.solicitud.id);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    FlatButton(
                                      child: Text('Cancelar'),
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
                          Icons.assignment_turned_in,
                          color: Colors.green,
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
    final providerSolicitud = SolicitudDataProvider();
    final fileURL = await providerSolicitud.getImageUserSolicitud(path);
    if (this.mounted) {
      setState(() {
        imgUrl = fileURL;
      });
    }
  }

  void _submit(BuildContext context) {
    if (!formkey.currentState.validate()) return;
    formkey.currentState.save();

    providerSolicitud.cancelarSolicitud(
        widget.solicitud.id, true, razonCancelacion);
    Navigator.of(context).pop();
  }

  void _irDetalleSolicitud(BuildContext context, Solicitud misolicitud) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (c) {
          return DetalleSolicitudActivaPage(misolicitud);
        },
      ),
    );
  }
}
