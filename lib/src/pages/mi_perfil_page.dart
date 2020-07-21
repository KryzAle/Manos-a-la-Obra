import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:manos_a_la_obra/src/bloc/provider.dart';
import 'package:manos_a_la_obra/src/models/usuario_model.dart';

class MiPerfilPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final userBloc = Provider.usuario(context);
    return Scaffold(
      body: StreamBuilder(
        stream: userBloc.getUsuario,
        builder: (BuildContext context, AsyncSnapshot<Usuario> snapshot) {
          if (snapshot.hasData) {
            return CustomScrollView(
              slivers: <Widget>[
                _crearAppbar(context, snapshot.data),
                SliverList(
                  delegate: SliverChildListDelegate([
                    _crearCardDatos(context,snapshot.data),
                    _crearCardDirecciones(snapshot.data),
                  ])
                )
              ],
            );
          }else{
            return Container();
          }
        }
      )
      
    );
  }

  Widget _crearDato(String label, String data) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: <Widget>[
          Text('$label : ', style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.0
          ),
          ),
          Text(data,style: TextStyle(
            fontSize: 15.0
          ),),
        ],
      ),
    );
  }

  Widget _crearAppbar(BuildContext context, Usuario usuario) {
    return SliverAppBar(
      elevation: 2.0,
      expandedHeight: 250.0,
      floating: false,
      leading: GestureDetector(child: Icon(Icons.arrow_back_ios,color: Colors.white,), onTap: (){Navigator.pop(context);},),
      pinned: true,
      actions: <Widget>[
        Container(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            child: Icon(Icons.photo_camera, color: Colors.white,),
            onTap: (){
              Navigator.pushNamed(context, 'editar_foto',arguments: usuario);
            },
          ),
        )
      ],
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(usuario.nombre, style: TextStyle(color: Colors.white, fontSize: 18.0),),
        background: Hero(
          tag: usuario.cedula,
          child: FadeInImage(
              image: _getImage(usuario.fotoUrl),
              placeholder: AssetImage('assets/rol.gif'),
              fit: BoxFit.cover,
            ),
        ),
        ),
    );
  }

  _crearCardDatos(BuildContext context, Usuario usuario) {
    return Container(
      width: 50.0,
      child: Card(
        color: Colors.grey[200],
        margin: EdgeInsets.symmetric(vertical: 20.0),
        elevation: 3.0,
        borderOnForeground: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        semanticContainer: true,

        child:  Container(
          padding: EdgeInsets.only(top: 15.0, right: 20.0, left: 20.0, bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Datos Personales', 
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0
                ),
              ),
              SizedBox(height: 10.0,),
              _crearDato('Cedula', usuario.cedula),
              _crearDato('Proveedor', usuario.proveedor?'Si':'No'),
              _crearDato('Nombre', usuario.nombre),
              _crearDato('Celular', usuario.telefono),
               Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(child: Container()),
                  InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, 'editar_perfil');
                    },
                    child: Row(
                      children: <Widget>[
                        Text('Editar',style: TextStyle(color: Colors.deepOrangeAccent),),
                        Icon(Icons.keyboard_arrow_right, color: Colors.deepOrangeAccent,)

                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 10.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(child: Container()),
                  InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, 'cambiar_password');
                    },
                    child: Row(
                      children: <Widget>[
                        Text('Cambiar Contraseña',style: TextStyle(color: Colors.deepOrangeAccent)),
                        Icon(Icons.keyboard_arrow_right,color: Colors.deepOrangeAccent,)
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _crearCardDirecciones(Usuario data) {
     return Container(
      width: 50.0,
      child: Card(
        color: Colors.grey[200],
        elevation: 3.0,
        borderOnForeground: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        semanticContainer: true,

        child:  Container(
          padding: EdgeInsets.only(top: 15.0, right: 20.0, left: 20.0, bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Mis Direcciones', 
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0
                ),
              ),
              SizedBox(height: 10.0,),
              _crearDato('Nombre', 'Mi Casa 1'),
              _crearDato('Calle Principal', 'Antonio Salas'),
              _crearDato('Calle Secundaria', 'Av. Atahualpa'),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text('Editar',style: TextStyle(color: Colors.deepOrangeAccent),),
                  Icon(Icons.keyboard_arrow_right, color: Colors.deepOrangeAccent,)
                ],
              ),
             
            ],
          ),
        ),
      ),
    );
  }

  ImageProvider _getImage(String url) {
    if(url!=null){
      return NetworkImage(url);
    }else{
      return AssetImage('assets/no-image.png');
    }
  }
}