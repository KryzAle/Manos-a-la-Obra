import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manos_a_la_obra/src/bloc/provider.dart';
import 'package:manos_a_la_obra/src/models/usuario_model.dart';
import 'package:manos_a_la_obra/src/providers/user_data_provider.dart';

class EditarFotoPage extends StatefulWidget {
  EditarFotoPage({Key key}) : super(key: key);

  @override
  _EditarFotoPageState createState() => _EditarFotoPageState();
}

class _EditarFotoPageState extends State<EditarFotoPage> {
  final usuarioProvider = UserDataProvider();
  File foto;
  @override
  Widget build(BuildContext context) {
    final Usuario usuario = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Foto del perfil', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        leading: InkWell(
          child: Icon(Icons.arrow_back_ios, color: Colors.white,),
          onTap: (){
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 20.0),
            child: InkWell(
              child: Icon(Icons.edit,color: Colors.white,),
              onTap: _mostrarBottomSheet,
            ),
          )
        ],
      ),
      body: _dibujarFotoPerfil(usuario),
    );
  }
  _mostrarBottomSheet(){
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context){
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'Tomar foto', 
                        textAlign: TextAlign.center,
                      ),
                      onTap: _tomarFoto,
                    ),
                    Divider(color: Colors.grey,),
                    ListTile(
                      title: Text(
                        'Seleccionar foto',
                        textAlign: TextAlign.center,
                      ),
                      onTap: _seleccionarFoto,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.white,
                ),
                child: ListTile(
                  title: Text(
                    'Cancelar',
                    textAlign: TextAlign.center,
                  ),
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                )
              ),
            ],

          ),
        );
      }
    );
  }

  Widget _dibujarFotoPerfil(Usuario usuario) {
    return Center(
      child:Hero(
        tag: usuario.cedula,
        child: Container(
          height: MediaQuery.of(context).size.height/2,
          width: double.infinity,
          child: _obtenerImagen(usuario.fotoUrl),
        ),
      )
    );
  }
  _seleccionarFoto()async{
    await _procesarImagen(ImageSource.gallery);
  }
  _tomarFoto()async{
    await _procesarImagen(ImageSource.camera);
  }
  _procesarImagen(ImageSource origen)async{
    final usuarioBloc = Provider.usuario(context);
    try {
      final fotoPicker = await ImagePicker().getImage(
        source: origen
      );
      Navigator.of(context).pop();
      if(fotoPicker?.path!=null){
        foto = File(fotoPicker.path);
        _mostrarDialog();
        await usuarioBloc.updateImageUsuario(foto);
        imageCache.clear();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }else{
        foto = null;
      }
      setState(() {

      });
    } catch (e) {
      print(e);
    }
  }

  Widget _obtenerImagen(String url) {
    if(foto!=null){
      return Image(image: FileImage(foto) ,fit: BoxFit.cover);
    }else{
      if(url!=null){
        return Image(image: NetworkImage(url) ,fit: BoxFit.cover);
      }
      else{
        return Image(image: AssetImage('assets/jar-loading.gif') ,fit: BoxFit.cover,);
      }
    }
  }

  void _mostrarDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 20.0,),
            Text(
              "Guardando...",
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),);
      }
    );
  }
}