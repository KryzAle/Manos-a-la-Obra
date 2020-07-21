import 'package:flutter/material.dart';
import 'package:manos_a_la_obra/src/bloc/provider.dart';
import 'package:manos_a_la_obra/src/bloc/usuario_bloc.dart';
import 'package:manos_a_la_obra/src/models/usuario_model.dart';

class EditarPerfilPage extends StatefulWidget {
  @override
  _EditarPerfilPageState createState() => _EditarPerfilPageState();
}

class _EditarPerfilPageState extends State<EditarPerfilPage> {
  final formkey = GlobalKey<FormState>();
  Widget build(BuildContext context) {
  final usuarioBloc = Provider.usuario(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Datos',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_ios, color: Colors.white,),
          onTap: (){
            Navigator.pop(context);

          },
        ),
      ),
      body:Form(
        key: formkey,
        child: StreamBuilder(
          stream: usuarioBloc.getUsuario,
          builder: (BuildContext context, AsyncSnapshot<Usuario> snapshot) {
            if(snapshot.hasData){
              return Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: <Widget>[
                  _crearInputNombre(snapshot.data,usuarioBloc),
                  _crearInputTelefono(snapshot.data, usuarioBloc),
                  Expanded(child: Container()),
                  _crearBotonActualizar(usuarioBloc),
                ],
              ),
              );
            }
            return Container();
          }
        ),
      )
    );
  }

  Widget _crearInputNombre(Usuario usuario,UsuarioBloc usuarioBloc) {
    return StreamBuilder(
      stream: usuarioBloc.getNombre,
      initialData: usuario.nombre != null? usuario.nombre : '',
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 30.0),
          child: TextFormField(
            initialValue: snapshot.data,
            decoration: InputDecoration(
              hintText: 'Juan Perez',
              labelText: 'Nombre',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelStyle: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold
              ),
              border: OutlineInputBorder(),
            ),
            onSaved: (value) {
              usuarioBloc.cambiarNombre(value);
            },
          ),
        );
      }
    );
  }

  Widget _crearInputTelefono(Usuario usuario, UsuarioBloc usuarioBloc) {
    String telefono = usuario.telefono != null? usuario.telefono : '';
    return StreamBuilder(
      stream: usuarioBloc.getTelefono,
      initialData: usuario.telefono != null? usuario.telefono : '',
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return Container(
          margin: EdgeInsets.symmetric(vertical:10.0),
          child: TextFormField(
            initialValue: snapshot.data,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              counter: Text('${telefono?.length.toString()}/10'),
              hintText: '0987654321',
              labelText: 'Telefono',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelStyle: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold
              ),
              border: OutlineInputBorder(),
            ),
            onChanged: (value){
              telefono = value;
            },
            onSaved: (value) {
              usuarioBloc.cambiarTelefono(value);
            },
            validator: (value){
              if(value.length < 10 || value.length>10){
                return snapshot.error;
              }else{
                return null;
              }
            },
          ),
        );
      }
    );
  }

  Widget _crearBotonActualizar(UsuarioBloc usuarioBloc) {
    return Container(
      padding: EdgeInsets.all(10.0),
      width: double.infinity,
      child: RaisedButton(
        padding: EdgeInsets.all(15.0),
        onPressed: ()=>_submit(usuarioBloc),
        child: Container(
          child: Text('Actualizar', textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 17.0),)
        ),
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
          side: BorderSide(color: Colors.orangeAccent),
        ),
        color: Colors.orangeAccent,
      ),
    );
  }

  void _submit(UsuarioBloc usuarioBloc) async{
    if (!formkey.currentState.validate()) return;
    formkey.currentState.save();
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
    await usuarioBloc.actualizarUsuario();
    Navigator.pop(context);
    Navigator.pop(context);
  }
}