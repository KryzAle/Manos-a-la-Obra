import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:manos_a_la_obra/src/models/direccion_model.dart';
import 'package:manos_a_la_obra/src/providers/direccion_provider.dart';

class FormDireccionPage extends StatefulWidget {
  FormDireccionPage({Key key}) : super(key: key);

  @override
  _FormDireccionPageState createState() => _FormDireccionPageState();
}

class _FormDireccionPageState extends State<FormDireccionPage> {
  final formkey = GlobalKey<FormState>();
  TextStyle styleButton = TextStyle(color: Colors.white, fontSize: 17.0);
  Completer<GoogleMapController> _controller = Completer();
  Direccion _direccion;
  Set<Marker> _markers = HashSet<Marker>();
  @override
  Widget build(BuildContext context) {
    _direccion = ModalRoute.of(context).settings.arguments;
    final CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(_direccion.latitud, _direccion.longitud),
      zoom: 17.0,
    );
    final _marker = Marker(
      position: LatLng(_direccion.latitud, _direccion.longitud),
      markerId: MarkerId('ubicacion'),
    );
    _markers.add(_marker);
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: <Widget>[
          Container(
            child: SingleChildScrollView(
              child: Form(
                  key: formkey,
                  child: Column(
                    children: <Widget>[
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
                      _crearCard(),
                      _crearInputNombre(),
                      _crearInputCallePrincipal(),
                      _crearInputNumeroVivienda(),
                      _crearInputCalleSecundaria(),
                      _crearInputReferencia(),
                      SizedBox(
                        height: 40.0,
                      )
                    ],
                  )),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _crearBotonesGuardar(),
          )
        ],
      ),
    );
  }

  Widget _crearBotonesGuardar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width / 2,
          child: RaisedButton(
            padding: EdgeInsets.all(15.0),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Container(
                child: Text(
              'Cancelar',
              textAlign: TextAlign.center,
              style: styleButton,
            )),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 2,
          child: RaisedButton(
            padding: EdgeInsets.all(15.0),
            onPressed: () => _submit(),
            child: Container(
                child: Text(
              'Guardar Direccion',
              textAlign: TextAlign.center,
              style: styleButton,
            )),
            color: Colors.deepOrangeAccent,
          ),
        ),
      ],
    );
  }

  Widget _crearInputNombre() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      child: TextFormField(
        initialValue: _direccion.nombre,
        decoration: InputDecoration(
          hintText: 'ej: Mi casa',
          labelText: 'Nombre o alias',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          border: OutlineInputBorder(),
        ),
        onSaved: (value) {
          _direccion.nombre = value;
        },
        validator: (value) {
          if (value.length == 0) {
            return 'Dato Faltante';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget _crearInputCallePrincipal() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      child: TextFormField(
        initialValue: _direccion.callePrincipal,
        decoration: InputDecoration(
          hintText: 'ej: Antonio Jose Sucre',
          labelText: 'Calle Principal',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          border: OutlineInputBorder(),
        ),
        onSaved: (value) {
          _direccion.callePrincipal = value;
        },
        validator: (value) {
          if (value.length == 0) {
            return 'Dato Faltante';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget _crearInputCalleSecundaria() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      child: TextFormField(
        initialValue: _direccion.calleSecundaria,
        decoration: InputDecoration(
          hintText: 'ej: Antonio Jose Sucre',
          labelText: 'Calle Secundaria',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          border: OutlineInputBorder(),
        ),
        onSaved: (value) {
          _direccion.calleSecundaria = value;
        },
        validator: (value) {
          if (value.length == 0) {
            return 'Dato Faltante';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget _crearInputNumeroVivienda() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      child: TextFormField(
        initialValue: _direccion.numeroVivienda,
        decoration: InputDecoration(
          labelText: 'Numero de Vivienda',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          border: OutlineInputBorder(),
        ),
        onSaved: (value) {
          _direccion.numeroVivienda = value;
        },
        validator: (value) {
          if (value.length == 0) {
            return 'Dato Faltante';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget _crearInputReferencia() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      child: TextFormField(
        initialValue: _direccion.referencia,
        decoration: InputDecoration(
          labelText: 'Referencia',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          border: OutlineInputBorder(),
        ),
        onSaved: (value) {
          _direccion.referencia = value;
        },
        validator: (value) {
          if (value.length == 0) {
            return 'Dato Faltante';
          } else {
            return null;
          }
        },
      ),
    );
  }

  void _submit() async {
    final direccionProvider = DireccionProvider();
    if (!formkey.currentState.validate()) return;
    formkey.currentState.save();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Guardando...",
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          );
        });
    if (_direccion.id != null) {
      _direccion.latitud = _markers.first.position.latitude;
      _direccion.longitud = _markers.first.position.longitude;
      await direccionProvider.editarDireccion(_direccion);
    } else {
      await direccionProvider.createDireccion(_direccion);
    }
    Navigator.pop(context);
    Navigator.pop(context);
  }

  Widget _crearCard() {
    final children = List<Widget>();
    children.add(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Tu posicion actual',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          _direccion.ubicacionMap,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    ));
    if (_direccion.id != null) {
      children.add(RaisedButton(
        padding: EdgeInsets.all(12.0),
        onPressed: () async {
          final result =
              await Navigator.pushNamed(context, 'map', arguments: true);
          if (result != null) {
            final Placemark newUbication = result;
            _direccion.latitud = newUbication.position.latitude;
            _direccion.longitud = newUbication.position.longitude;
            final latlng = LatLng(newUbication.position.latitude,
                newUbication.position.longitude);
            _direccion.ubicacionMap = newUbication.name;
            _addMarket(latlng);
            moverMap(latlng);
          }
        },
        child: Text(
          'Cambiar ubicacion',
          style: styleButton,
        ),
        color: Colors.deepOrangeAccent,
      ));
    }
    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }

  void moverMap(LatLng params) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: params,
        zoom: 17.0,
      ),
    ));
  }

  void _addMarket(LatLng argument) {
    final marker = _markers.first.copyWith(positionParam: argument);
    _markers.clear();
    _markers.add(marker);
    setState(() {});
  }
}
