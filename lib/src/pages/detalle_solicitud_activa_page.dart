import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:manos_a_la_obra/src/models/solicitud_model.dart';
import 'package:manos_a_la_obra/src/pages/item_descripcion.dart';
import 'package:manos_a_la_obra/src/providers/solicitud_provider.dart';
import 'package:manos_a_la_obra/src/widgets/item_header_solicitud.dart';

class DetalleSolicitudActivaPage extends StatefulWidget {
  DetalleSolicitudActivaPage(this.solicitud, {Key key}) : super(key: key);

  final Solicitud solicitud;

  @override
  _DetalleSolicitudPageState createState() => _DetalleSolicitudPageState();
}

class _DetalleSolicitudPageState extends State<DetalleSolicitudActivaPage> {
  final providerSolicitud = SolicitudDataProvider();
  final formkey = GlobalKey<FormState>();
  String razonCancelacion;
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = HashSet<Marker>();

  @override
  Widget build(BuildContext context) {
    final CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(widget.solicitud.direccion["latitud"],
          widget.solicitud.direccion["longitud"]),
      zoom: 17.0,
    );
    final _marker = Marker(
      position: LatLng(widget.solicitud.direccion["latitud"],
          widget.solicitud.direccion["longitud"]),
      markerId: MarkerId('ubicacion'),
    );
    _markers.add(_marker);
    return Material(
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.hardEdge,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SolicitudDetalleHeader(widget.solicitud, false),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
              child: SizedBox(
                width: double.infinity,
                // height: double.infinity,
                child: RaisedButton(
                  onPressed: () => {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: Text("Finalizar esta Solicitud"),
                              content: Text("¿La solicitud fue completada?"),
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
                        })
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(
                          Icons.done_outline,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Finalizar Solicitud",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  padding: const EdgeInsets.all(12),
                  color: Colors.green,
                  highlightColor: Colors.orange.shade400,
                  splashColor: Colors.orange.shade400,
                  elevation: 8,
                  highlightElevation: 10,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: SizedBox(
                width: double.infinity,
                child: OutlineButton(
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
                ),
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
                    DescriptionText("Ubicación del Cliente", ""),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 3,
                      child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: _kGooglePlex,
                        zoomControlsEnabled: false,
                        markers: _markers,
                        rotateGesturesEnabled: false,
                        scrollGesturesEnabled: false,
                        liteModeEnabled: false,
                        zoomGesturesEnabled: false,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                      ),
                    ),
                    SizedBox(height: 10.0)
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
