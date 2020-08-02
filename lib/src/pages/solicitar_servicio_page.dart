import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manos_a_la_obra/src/bloc/provider.dart';
import 'package:manos_a_la_obra/src/bloc/servicio_bloc.dart';
import 'package:manos_a_la_obra/src/bloc/solicitud_bloc.dart';
import 'package:manos_a_la_obra/src/models/servicio_model.dart';
import 'package:manos_a_la_obra/src/models/solicitud_model.dart';
import 'package:manos_a_la_obra/src/providers/user_data_provider.dart';
import 'package:image_picker/image_picker.dart';

class SolicitarServicioPage extends StatefulWidget {
  final nombreServicio;
  final idServicio;
  SolicitarServicioPage(
      {Key key, @required this.nombreServicio, @required this.idServicio})
      : super(key: key);

  @override
  _SolicitarServicioPageState createState() => _SolicitarServicioPageState();
}

class _SolicitarServicioPageState extends State<SolicitarServicioPage> {
  bool mostrarBoton = true;
  int count = 0;
//componente de firebase storage

  //Llave global para obtener el estado del formulario
  final formkey = GlobalKey<FormState>();
  Servicio servicio = new Servicio();
  Solicitud solicitud = new Solicitud();

  final listaImagenes = new List<File>();
  List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final categoriaBloc = Provider.categoria(context);
    //retorna un scaffold con el formulario completo
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
                        widget.nombreServicio,
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
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Dirección para tu solicitud",
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 16),
                          hintText: "Mi casa",
                          border: OutlineInputBorder(),
                        ),
                        initialValue: solicitud.direccion,
                        onSaved: (value) => solicitud.direccion = value,
                        validator: (value) {
                          if (value.length < 6) {
                            return 'Debe ser mayor a 6 caracteres';
                          } else {
                            return null;
                          }
                        },
                      ),
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

  //se crea la lista de categorias
  List<String> crearLista(lista) {
    final List<String> items = List();
    for (var categoria in lista) {
      items.add(categoria.nombre);
    }
    return items;
  }

  //Boton de Agregar Imagen

  void _submit(BuildContext context) {
    final usuarioactual = UserDataProvider();
    final servicioBloc = ServicioBloc();
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
    //se obtiene el id del usuario actual a traves del userdataprovider
    usuarioactual.getIdCurrentUser().then((value) async {
      //se asigna el value que contiene el id ademas de la lista de paths de las imagenes
      solicitud.idCliente = value;

      solicitud.idServicio = widget.idServicio;
      solicitud.fechaInicio = Timestamp.fromDate(DateTime.now());
      print(widget.idServicio);
      //se envia al bloc el objeto Servicio cargado con la informacion del formulario
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
                  //si la tarea se completa se muestra el boton de continuar para regresar al inicio
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
      //se crea una instancia para modificar el usuario y convertirlo en proveedor al cambiar el atributo proveedor a true
    });
  }
}
