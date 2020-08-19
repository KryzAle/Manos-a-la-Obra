import 'dart:io';
import 'package:flutter/material.dart';
import 'package:manos_a_la_obra/src/bloc/provider.dart';
import 'package:manos_a_la_obra/src/bloc/servicio_bloc.dart';
import 'package:manos_a_la_obra/src/models/direccion_model.dart';
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

  //Llave global para obtener el estado del formulario
  final formkey = GlobalKey<FormState>();
  Servicio servicio = new Servicio();
  final listaImagenes = new List<File>();
  List<Widget> children;
  Direccion _direccion;

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
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.file(
              listaImagenes[index],
              width: 130,
            ),
          ),
          VerticalDivider(),
          IconButton(
            iconSize: 40,
            icon: Icon(Icons.delete_forever),
            color: Colors.red,
            onPressed: () {
              setState(() {
                count--;
                listaImagenes.removeAt(index);
                children.removeAt(index);
                mostrarBoton = true;
              });
            },
          ),
        ],
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
    final direccionBloc = Provider.direccion(context);

    //se genera la lista de widgets que retornan la imagen dentro de un Cliprrect
    children = new List.generate(count, (int i) {
      return Column(
        children: <Widget>[
          _buildImage(i),
          Divider(),
        ],
      );
    });
    //Si la tarea de subida es diferente de nulo entonces se crea un StreamBuilder para gestionar el evento de subida

    //Formulario
    final categoriaBloc = Provider.categoria(context);
    //retorna un scaffold con el formulario completo
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop()),
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
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Nombre de tu servicio",
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 16),
                        hintText: "Ejmp. Encofrados Ecuador",
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
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Detalle de tus servicios",
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 16),
                        hintText:
                            "Ejemplo: Se alquila encofrado y maquinaria para construcción",
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
                    "Categoria para tu servicio",
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
                    "Selecciona una direccion donde brindas tu servicio",
                    style:
                        TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
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
                              if (newValue != null) _direccion = newValue;
                            });
                          },
                          items: _crearListaDirecciones(snapshot.data),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),

                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Imagenes de tu servicio",
                        style: TextStyle(
                            fontSize: 17.0, fontWeight: FontWeight.bold),
                      ),
                      VerticalDivider(),
                      if (mostrarBoton)
                        _buildActionButton(
                          key: Key('retake'),
                          text: 'Foto',
                          onPressed: () => captureImage(ImageSource.gallery),
                        ),
                    ],
                  ),
                  //boton de agregar imagenes

                  SizedBox(height: 30),
                  Column(
                    children: <Widget>[
                      Column(children: children),
                      //_preBuildImage(children),
                    ],
                  ),
                  SizedBox(height: 60),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    width: double.infinity,
                    child: RaisedButton(
                      padding: EdgeInsets.all(15.0),
                      onPressed: () => _submit(context),
                      child: Container(
                          child: Text(
                        'Guardar',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 17.0),
                      )),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                        side: BorderSide(color: Colors.orangeAccent),
                      ),
                      color: Colors.orangeAccent,
                    ),
                  )
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
      value: null,
    ));
    return itemsLista;
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

  //se ejecuta al pulsar el boton guardar en el formulario
  void _submit(BuildContext context) {
    //genera el provider para obtener el usuario actual, el bloc de servicio y una lista de paths de las imagenes
    final usuarioactual = UserDataProvider();
    final usuarioBloc = Provider.usuario(context);
    final servicioBloc = ServicioBloc();

    //valida que la categoría se ha señalado
    if (servicio.categoria == null) {
      final snackBar =
          SnackBar(content: Text('¡Ups! Olvidaste marcar una categoría'));
      Scaffold.of(context).showSnackBar(snackBar);
    } else {
      if (_direccion == null) {
        final snackBar =
            SnackBar(content: Text('¡Ups! Olvidaste selecionar una dirección'));
        Scaffold.of(context).showSnackBar(snackBar);
      } else {
        //si pasa la primera validacion, se ejecutan las validaciones: validate de los textformfield del formulario
        if (!formkey.currentState.validate()) return;
        //en caso se pasaron las validaciones se guarda el estado del formulario
        formkey.currentState.save();
        //se recorre la lista de imagenes

        //se verifica que la lista de imagenes no este vacia
        if (listaImagenes.isNotEmpty) {
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
            final usuario = usuarioBloc.usuario;

            Map<String, dynamic> mapUsuario = {
              "id": value,
              "nombre": usuario.nombre,
              "foto": usuario.foto,
            };
            servicio.usuario = new Map<String, dynamic>();
            servicio.usuario = mapUsuario;
            //se envia al bloc el objeto Servicio cargado con la informacion del formulario
            Map<String, dynamic> mapDireccion = {
              "latitud": _direccion.latitud,
              "longitud": _direccion.longitud,
            };
            servicio.direccion = new Map<String, dynamic>();
            servicio.direccion = mapDireccion;

            await servicioBloc.insertarServicio(servicio, value, listaImagenes);
            Navigator.of(context).pop();
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      title: Text("Guardado!"),
                      content: Text("Servicio Registrado"),
                      actions: <Widget>[
                        //si la tarea se completa se muestra el boton de continuar para regresar al inicio
                        FlatButton(
                          child: Text('Continuar'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                        ),
                      ]);
                });
            //se crea una instancia para modificar el usuario y convertirlo en proveedor al cambiar el atributo proveedor a true
          });
        } else {
          final snackBar = SnackBar(
              content: Text('¡Asegurate de adjutar al menos una Imagen!'));
          Scaffold.of(context).showSnackBar(snackBar);
        }
      }
    }
  }
}
