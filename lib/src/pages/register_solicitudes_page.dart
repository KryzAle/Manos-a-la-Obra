import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:manos_a_la_obra/src/bloc/provider.dart';
import 'package:manos_a_la_obra/src/bloc/servicio_bloc.dart';
import 'package:manos_a_la_obra/src/models/servicio_model.dart';
import 'package:manos_a_la_obra/src/providers/user_data_provider.dart';
import 'package:image_picker/image_picker.dart';

class RegisterSolicitudesPage extends StatefulWidget {
  RegisterSolicitudesPage({Key key}) : super(key: key);

  @override
  _RegisterSolicitudesPageState createState() =>
      _RegisterSolicitudesPageState();
}

class _RegisterSolicitudesPageState extends State<RegisterSolicitudesPage> {
  bool mostrarBoton = true;
  int count = 0;
//componente de firebase storage
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://manos-a-la-obra-44f76.appspot.com');
  StorageUploadTask _uploadTask;
  //Llave global para obtener el estado del formulario
  final formkey = GlobalKey<FormState>();
  Servicio servicio = new Servicio();
  final listaImagenes = new List<File>();

//metodo para capturar la imagen con el picker, espera que el usuario selecciona la imagen de su Storage
  Future<void> captureImage(ImageSource imageSource) async {
    try {
      final imageFile = await ImagePicker.pickImage(source: imageSource);
      setState(() {
        //se valida si el contador es menor que las 3 imagenes maximas
        if (count < 3 && imageFile != null) {
          count = count + 1;
          //se agrega el archivo a la lista de imagenes
          listaImagenes.add(imageFile);
        }
        //si ya se encuentran 3 imagenes desablilita el boton de agregar imagen
        if (count == 3 && imageFile != null) {
          mostrarBoton = false;
        }
      });
    } catch (e) {
      print(e);
    }
  }

//devuelve un widget que retorna una Cliprrect con la imagen
  Widget _buildImage(index) {
    if (listaImagenes[index] != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.file(
          listaImagenes[index],
          height: 200,
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Icon(
          Icons.image,
          size: 50.0,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //se genera la lista de widgets que retornan la imagen dentro de un Cliprrect
    List<Widget> children = new List.generate(count, (int i) {
      return Row(
        children: <Widget>[VerticalDivider(), _buildImage(i)],
      );
    });
    //Si la tarea de subida es diferente de nulo entonces se crea un StreamBuilder para gestionar el evento de subida
    if (_uploadTask != null) {
      return StreamBuilder<StorageTaskEvent>(
          //carga como stream los eventos de subida
          stream: _uploadTask.events,
          builder: (_, snapshot) {
            var event = snapshot?.data?.snapshot;
            //porcentaje de subida
            double progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;
            //se retorna un scaffold con el AlertDialog cuando se da submit en el formulario
            return Scaffold(
                body: Center(
              child: AlertDialog(
                actions: <Widget>[
                  //si la tarea se completa se muestra el boton de continuar para regresar al inicio
                  if (_uploadTask.isComplete)
                    FlatButton(
                      child: Text('Continuar'),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, "home");
                      },
                    ),
                ],
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('Guardando...'),
                      Column(
                        children: [
                          if (_uploadTask.isPaused)
                            FlatButton(
                              child: Icon(Icons.play_arrow),
                              onPressed: _uploadTask.resume,
                            ),

                          if (_uploadTask.isInProgress)
                            FlatButton(
                              child: Icon(Icons.pause),
                              onPressed: _uploadTask.pause,
                            ),

                          // Muestra la barra de progreso de subida y el porcentaje
                          LinearProgressIndicator(value: progressPercent),
                          Text(
                              '${(progressPercent * 100).toStringAsFixed(2)} % '),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ));
          });
    }
//Formulario
    final categoriaBloc = Provider.categoria(context);
    categoriaBloc.cargarCategoria();
    //retorna un scaffold con el formulario completo
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.popAndPushNamed(context, 'home'),
        ),
        title: Text("Registrar Servicio"),
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) => Center(
          child: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20),
                  Text(
                    "Selecciona una categoria para tu servicio",
                    style:
                        TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                  ),
                  StreamBuilder(
                    stream: categoriaBloc.getCategoria,
                    builder:
                        (BuildContext context, AsyncSnapshot<List> snapshot) {
                      if (snapshot.hasData) {
                        return DropdownButton(
                          hint: Text('Seleccionar..'),
                          value: servicio.categoria,
                          onChanged: (newValue) {
                            setState(() {
                              servicio.categoria = newValue;
                            });
                          },
                          items: crearLista(snapshot.data).map((location) {
                            return DropdownMenuItem(
                              child: new Text(location),
                              value: location,
                            );
                          }).toList(),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Nombre del Servicio",
                    style:
                        TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: 250,
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Tu nombre o el de tu Negocio",
                        border: OutlineInputBorder(),
                      ),
                      initialValue: servicio.nombre,
                      onSaved: (value) => servicio.nombre = value,
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
                    "Detalle de tu servicio",
                    style:
                        TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: 300,
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Detalle de tus servicios",
                        border: OutlineInputBorder(),
                      ),
                      initialValue: servicio.descripcion,
                      maxLines: 5,
                      onSaved: (value) => servicio.descripcion = value,
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
                    "Imagenes de tu servicio",
                    style:
                        TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
                  Column(
                    children: <Widget>[
                      //Column(children: children),
                      _preBuildImage(children),
                    ],
                  ),
                  SizedBox(height: 60),
                  RaisedButton(
                    color: Colors.greenAccent,
                    onPressed: () => _submit(context),
                    child: new Text("Guardar"),
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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

//Devuelve un widget que coloca la imagen en el ConstrainedBox y muestra el boton de agregar imagen.
  Widget _preBuildImage(children) {
    return ConstrainedBox(
        constraints: BoxConstraints.expand(height: 40.0),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //se carga el Row con la lista de imagenes
              Row(children: children),
              VerticalDivider(),
              //boton de agregar imagenes
              if (mostrarBoton)
                _buildActionButton(
                  key: Key('retake'),
                  text: 'Foto',
                  onPressed: () => captureImage(ImageSource.gallery),
                ),
            ]));
  }

//Boton de Agregar Imagen
  Widget _buildActionButton({Key key, String text, Function onPressed}) {
    return FloatingActionButton(
      key: key,
      onPressed: onPressed,
      child: Icon(Icons.add),
    );
  }

//El metodo recibe el archivo a subirse, le asigna un path que es retornado e inicia la subida al cambiar el estado del _uploadTask
  String _startUpload(file) {
    String filePath = 'servicios/${DateTime.now()}.png';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(file);
    });
    return filePath;
  }

//se ejecuta al pulsar el boton guardar en el formulario
  void _submit(BuildContext context) {
    //genera el provider para obtener el usuario actual, el bloc de servicio y una lista de paths de las imagenes
    final usuarioactual = UserDataProvider();
    final servicioBloc = ServicioBloc();
    final listaPaths = List<String>();

//valida que la categoría se ha señalado
    if (servicio.categoria == null) {
      final snackBar =
          SnackBar(content: Text('¡Ups! Olvidaste marcar una categoría'));
      Scaffold.of(context).showSnackBar(snackBar);
    } else {
      //si pasa la primera validacion, se ejecutan las validaciones: validate de los textformfield del formulario
      if (!formkey.currentState.validate()) return;
//en caso se pasaron las validaciones se guarda el estado del formulario
      formkey.currentState.save();
      //se recorre la lista de imagenes
      for (var imagen in listaImagenes) {
        String path = _startUpload(imagen);
        listaPaths.add(path);
      }
      //se verifica que la lista de imagenes no este vacia
      if (listaImagenes.isNotEmpty) {
        //se obtiene el id del usuario actual a traves del userdataprovider
        usuarioactual.getIdCurrentUser().then((value) {
          //se asigna el value que contiene el id ademas de la lista de paths de las imagenes
          servicio.idUsuario = value;
          servicio.evidencia = listaPaths;
          //se envia al bloc el objeto Servicio cargado con la informacion del formulario
          servicioBloc.insertarServicio(servicio);
          //se crea una instancia para modificar el usuario y convertirlo en proveedor al cambiar el atributo proveedor a true
          Firestore.instance
              .document("usuario/" + value)
              .updateData({"proveedor": true}).then(
                  (value) => print("Inscrito como proveedor"));
        });
      } else {
        final snackBar = SnackBar(
            content: Text('¡Asegurate de adjutar al menos una Imagen!'));
        Scaffold.of(context).showSnackBar(snackBar);
      }
    }
  }
}
