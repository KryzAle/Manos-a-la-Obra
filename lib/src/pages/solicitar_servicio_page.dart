import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manos_a_la_obra/src/bloc/provider.dart';
import 'package:manos_a_la_obra/src/bloc/solicitud_bloc.dart';
import 'package:manos_a_la_obra/src/models/direccion_model.dart';
import 'package:manos_a_la_obra/src/models/servicio_model.dart';
import 'package:manos_a_la_obra/src/models/solicitud_model.dart';
import 'package:manos_a_la_obra/src/models/usuario_model.dart';
import 'package:manos_a_la_obra/src/providers/user_data_provider.dart';

class SolicitarServicioPage extends StatefulWidget {
  final Servicio servicio;
  SolicitarServicioPage({Key key, @required this.servicio}) : super(key: key);

  @override
  _SolicitarServicioPageState createState() => _SolicitarServicioPageState();
}

class _SolicitarServicioPageState extends State<SolicitarServicioPage> {
  bool mostrarBoton = true;
  int count = 0;

  final formkey = GlobalKey<FormState>();
  Servicio servicio = new Servicio();
  Solicitud solicitud = new Solicitud();

  final listaImagenes = new List<File>();
  List<Widget> children;
  Direccion _direccion;

  @override
  Widget build(BuildContext context) {
    final direccionBloc = Provider.direccion(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop()),
        title: Text("Contratar Servicio"),
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) => Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Form(
                key: formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 32.0, left: 18, right: 16),
                      child: Text(
                        widget.servicio.nombre,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 25,
                          letterSpacing: 0.27,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Detallanos tu Problema",
                          labelStyle:
                              TextStyle(color: Colors.black87, fontSize: 16),
                          hintText: "Ejemplo: Necesito la reparacion de una TV",
                          border: OutlineInputBorder(),
                        ),
                        initialValue: solicitud.descripcion,
                        maxLines: 5,
                        onSaved: (value) => solicitud.descripcion = value,
                        validator: (value) {
                          if (value.length < 6) {
                            return 'Debe ser mayor a 6 caracteres';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "¿En donde necesitas el Servicio?",
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    StreamBuilder(
                      stream: direccionBloc.getDireccion,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Direccion>> snapshot) {
                        if (snapshot.hasData) {
                          return DropdownButton(
                            hint: Text('Seleccionar..'),
                            value: _direccion,
                            onChanged: (newValue) {
                              setState(() {
                                if (newValue != ''){
                                _direccion = newValue;
                              }else{
                                _direccion = null;
                                Navigator.pushNamed(context, 'map',arguments: false);
                              }
                              });
                            },
                            items: _crearListaDirecciones(snapshot.data),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _crearBotonContratar(),
            )
          ],
        ),
      ),
    );
  }

  List<dynamic> crearLista(lista) {
    final List<String> items = List();
    for (var nombreDireccion in lista) {
      items.add(nombreDireccion.nombre);
    }
    items.add("+ Agregar una nueva dirección");
    return items;
  }

  List<DropdownMenuItem<dynamic>> _crearListaDirecciones(
      List<Direccion> listaDirecciones) {
    List<DropdownMenuItem<dynamic>> itemsLista = List();
    for (var value in listaDirecciones) {
      itemsLista.add(DropdownMenuItem(
        child: Text(value.nombre),
        value: value,
      ));
    }

    itemsLista.add(DropdownMenuItem(
      child: Text("+ Agregar una nueva dirección"),
      value: '',
    ));
    return itemsLista;
  }

  Widget _crearBotonContratar() {
    return Container(
      padding: EdgeInsets.all(10.0),
      width: double.infinity,
      child: RaisedButton(
        padding: EdgeInsets.all(15.0),
        onPressed: () => _submit(context),
        child: Container(
            child: Text(
          'Contratar',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 17.0),
        )),
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
          side: BorderSide(color: Colors.orangeAccent),
        ),
        color: Colors.orangeAccent,
      ),
    );
  }

  void _submit(BuildContext context) {
    final usuarioactual = UserDataProvider();
    final solicitudBloc = SolicitudBloc();

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
    usuarioactual.getIdCurrentUser().then((idCliente) async {
      usuarioactual.getUserDoc().then((usuario) {
        usuario.listen((event) async {
          Usuario usuario = new Usuario.fromMap(event.data);
          solicitud.idCliente = idCliente;
          solicitud.idProveedor = widget.servicio.usuario["id"];
          solicitud.idServicio = widget.servicio.id;
          Map<String, dynamic> mapCliente = {
            "nombre": usuario.nombre,
            "foto": usuario.foto,
            "telefono": usuario.telefono.replaceFirst("0", "593"),
          };
          solicitud.cliente = new Map<String, dynamic>();
          solicitud.cliente = mapCliente;
          Map<String, dynamic> mapProveedor = {
            "nombre": widget.servicio.usuario["nombre"],
            "foto": widget.servicio.usuario["foto"],
            "telefono": widget.servicio.usuario["telefono"],
          };
          solicitud.proveedor = new Map<String, dynamic>();
          solicitud.proveedor = mapProveedor;
          Map<String, dynamic> mapServicio = {
            "descripcion": widget.servicio.descripcion,
            "evidencia": widget.servicio.evidencia[0],
            "nombre": widget.servicio.nombre
          };
          solicitud.servicio = new Map<String, dynamic>();
          solicitud.servicio = mapServicio;

          solicitud.fechaSolicitud = Timestamp.fromDate(DateTime.now());

          Map<String, dynamic> mapDireccion = {
            "latitud": _direccion.latitud,
            "longitud": _direccion.longitud,
          };
          solicitud.direccion = new Map<String, dynamic>();
          solicitud.direccion = mapDireccion;

          await solicitudBloc.insertarSolicitud(solicitud);
          Navigator.of(context).pop();
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: Text("Solicitud Registrada!"),
                    content: Text(
                        "La solicitud ha sido recibida, el proveedor del servicio te contactará pronto"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Continuar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                      ),
                    ]);
              });
        });
      });
    });
  }
}
