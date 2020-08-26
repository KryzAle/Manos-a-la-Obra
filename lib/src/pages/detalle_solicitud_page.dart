import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:manos_a_la_obra/src/models/solicitud_model.dart';
import 'package:manos_a_la_obra/src/pages/item_descripcion.dart';
import 'package:manos_a_la_obra/src/providers/solicitud_provider.dart';
import 'package:manos_a_la_obra/src/widgets/item_header_solicitud.dart';

class DetalleSolicitudPage extends StatefulWidget {
  DetalleSolicitudPage(this.solicitud, {Key key}) : super(key: key);

  final Solicitud solicitud;

  @override
  _DetalleSolicitudPageState createState() => _DetalleSolicitudPageState();
}

class _DetalleSolicitudPageState extends State<DetalleSolicitudPage> {
  final providerSolicitud = SolicitudDataProvider();
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
            SolicitudDetalleHeader(widget.solicitud),
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
                              title: Text("Aceptar esta Solicitud"),
                              content: Text("¿Esta seguro?"),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Aceptar'),
                                  onPressed: () {
                                    providerSolicitud
                                        .aceptarSolicitud(widget.solicitud.id);
                                    Navigator.popAndPushNamed(
                                        context, "mis_solicitudes_activas");
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
                          Icons.work,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Aceptar Solicitud",
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
                              title: Text("Rechazar esta solicitud"),
                              content: Text("¿Esta seguro?"),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Rechazar'),
                                  onPressed: () {
                                    providerSolicitud
                                        .rechazarSolicitud(widget.solicitud.id);
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
                          Icons.cancel,
                          color: Colors.red,
                        ),
                      ),
                      Text(
                        "Rechazar Solicitud",
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  padding: const EdgeInsets.all(12),
                  borderSide: BorderSide(color: Colors.orange, width: 4),
                  color: Colors.white,
                  highlightColor: Colors.white70,
                  splashColor: Colors.orange.shade200,
                  highlightElevation: 0,
                  highlightedBorderColor: Colors.orange.shade400,
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
}
