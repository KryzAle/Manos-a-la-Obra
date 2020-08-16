import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manos_a_la_obra/src/bloc/login_bloc.dart';
import 'package:manos_a_la_obra/src/bloc/provider.dart';

class RegisterPage extends StatelessWidget {
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final loginBloc = Provider.of(context);
    loginBloc.resetValues();
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Form(
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .2),
                      _title(context),
                      SizedBox(height: 50),
                      _nombreFile(loginBloc),
                      SizedBox(height: 20),
                      _cedulaFile(loginBloc),
                      SizedBox(height: 20),
                      _mailField(loginBloc),
                      SizedBox(
                        height: 20.0,
                      ),
                      _passwordField(loginBloc),
                      SizedBox(height: 20),
                      _submitButton(context, loginBloc),
                      SizedBox(height: height * .14),
                      _loginAccountLabel(context),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
                top: 40, left: 0, child: _backButton(context, loginBloc)),
          ],
        ),
      ),
    );
  }

  Widget _title(BuildContext context) {
    return Text(
      'Registrarse',
      style: GoogleFonts.portLligatSans(
        textStyle: Theme.of(context).textTheme.headline4,
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
    );
  }

  Widget _nombreFile(LoginBloc loginBloc) {
    return StreamBuilder(
      stream: loginBloc.nombreStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          child: TextFormField(
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              icon: Icon(Icons.person_outline),
              hintText: 'Nombre',
            ),
            onSaved: (value){
              loginBloc.changeNombre(value);
            },
            validator: (value){
              if (value.length<10) {
                return 'Debe tener almenos 10 caracteres';
              }else{
                return null;
              }
            },
          ),
        );
      },
    );
  }

  Widget _cedulaFile(LoginBloc loginBloc) {
    return StreamBuilder(
      stream: loginBloc.cedulaStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          child: TextFormField(
            decoration: InputDecoration(
              icon: Icon(Icons.mail_outline),
              hintText: 'Cedula',
            ),
            onSaved: (value){
              loginBloc.changeCedula(value);
            },
            validator: (value){
              if (value.length!=10) {
                return 'Debe tener 10 digitos';
              }else{
                return null;
              }
            },
          ),
        );
      },
    );
  }

  Widget _mailField(LoginBloc loginBloc) {
    return StreamBuilder(
      stream: loginBloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(Icons.mail_outline),
              hintText: 'Correo Electronico',
            ),
            onSaved: (value){
              loginBloc.changeEmail(value);
            },
            validator: (value){
              Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp = new RegExp(pattern);
              if (!regExp.hasMatch(value)) {
                return 'Correo no valido';
              }else{
                return null;
              }
            },
          ),
        );
      },
    );
  }

  Widget _passwordField(LoginBloc loginBloc) {
    return StreamBuilder(
      stream: loginBloc.passwordStream,
      initialData: '',
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          child: TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(Icons.lock_outline),
              hintText: 'Contraseña',
            ),
            onSaved: (value){
              loginBloc.changePassword(value);
            },
            validator: (value){
              if (value.length<6) {
                return 'Debe tener mas de 6 caracteres';
              }else{
                return null;
              }
            },
          ),
        );
      },
    );
  }

  Widget _submitButton(BuildContext context, LoginBloc loginBloc) {
    return RaisedButton(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        child: Text(
          'Registrate',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      color: Colors.orange,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      onPressed:() => _register(context, loginBloc),
    );
  }

  Widget _loginAccountLabel(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacementNamed(context, 'login');
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Ya tienes una cuenta ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Inicia Sesion',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _backButton(BuildContext context, LoginBloc loginBloc) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacementNamed(context, 'welcome');
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Regresar',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  _register(BuildContext context, LoginBloc loginBloc) async {
    if (!formkey.currentState.validate()) return;
    formkey.currentState.save();
    final serviciosBloc = Provider.servicio(context);
    final direccionBloc = Provider.direccion(context);
    final usuarioBloc = Provider.usuario(context);
    final solicitudesBloc = Provider.solicitud(context);
    showDialog(
        context: context,
        barrierDismissible: false,
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
                  "Registrando...",
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                        fontSize: 25.0,
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          );
        });
        try {
          await loginBloc.register();
          usuarioBloc.cargarUsuario();
          loginBloc.resetValues();
          serviciosBloc.cargarServiciosUsuario();
          solicitudesBloc.cargarSolicitudesUsuario();
          direccionBloc.cargarDireccionUsuario();
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, 'home');
        } catch (e) {
          Navigator.pop(context);
          _mostrarAlerta(context, Icons.error_outline,
                  e.toString());
        }
  }

  void _mostrarAlerta(BuildContext context, IconData icon, String subtext) {
    showDialog(
        context: context,
        child: AlertDialog(
          elevation: 2.0,
          content: Text(subtext),
          title: Icon(icon,size: 70.0, color: Colors.red,),
          actions: <Widget>[
            FlatButton(
                onPressed: () => Navigator.of(context).pop(), child: Text('Ok'))
          ],
        ));
  }
}
