import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manos_a_la_obra/src/bloc/login_bloc.dart';
import 'package:manos_a_la_obra/src/bloc/provider.dart';

class LoginPage extends StatelessWidget {
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * .2),
                  _title(context),
                  SizedBox(height: 50),
                  _mailField(loginBloc),
                  SizedBox(
                    height: 20.0,
                  ),
                  _passwordField(loginBloc),
                  SizedBox(height: 20),
                  _submitButton(context, loginBloc),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    child: Text(
                      'Olvidaste tu contraseña ?',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                  _divider(),
                  _googleButton(context, loginBloc),
                  SizedBox(height: height * .055),
                  _createAccountLabel(context, loginBloc),
                ],
              ),
            ),
          ),
          Positioned(top: 40, left: 0, child: _backButton(context, loginBloc)),
        ],
      ),
    ));
  }

  Widget _title(BuildContext context) {
    return Text(
      'Iniciar Sesion',
      style: GoogleFonts.portLligatSans(
        textStyle: Theme.of(context).textTheme.headline4,
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
    );
  }

  Widget _passwordField(LoginBloc loginBloc) {
    return StreamBuilder(
      stream: loginBloc.passwordStream,
      initialData: '',
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(Icons.lock_outline),
              hintText: 'Contraseña',
              counterText: snapshot.data,
              errorText: snapshot.error,
            ),
            onChanged: loginBloc.changePassword,
          ),
        );
      },
    );
  }

  Widget _mailField(LoginBloc loginBloc) {
    return StreamBuilder(
      stream: loginBloc.emailStream,
      initialData: '',
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(Icons.mail_outline),
              hintText: 'Correo Electronico',
              counterText: snapshot.data,
              errorText: snapshot.error,
            ),
            onChanged: loginBloc.changeEmail,
          ),
        );
      },
    );
  }

  Widget _submitButton(BuildContext context, LoginBloc loginBloc) {
    return StreamBuilder(
      stream: loginBloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            alignment: Alignment.center,
            child: Text(
              'Iniciar Sesion',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          color: Colors.orange,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          onPressed: snapshot.hasData ? () => _login(loginBloc, context) : null,
        );
      },
    );
  }

  _login(LoginBloc loginBloc, BuildContext context) async {
    final usuarioBloc = Provider.usuario(context);
    final serviciosBloc = Provider.servicio(context);
    final direccionBloc = Provider.direccion(context);
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
                  "Iniciando Sesion...",
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                        fontSize: 25.0,
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          );
        });
    if (await loginBloc.login()) {
      usuarioBloc.cargarUsuario();
      direccionBloc.cargarDireccionUsuario();
      serviciosBloc.cargarServiciosUsuario();
      solicitudesBloc.cargarSolicitudesUsuario();
      solicitudesBloc.cargarNuevasSolicitudesUsuario();
      loginBloc.resetValues();
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      Navigator.pop(context);
      _mostrarAlerta(context, 'Datos Incorrectos',
          'Tu contraseña o email son incorrectos');
    }
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('o'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _googleButton(BuildContext context, LoginBloc loginBloc) {
    return RaisedButton(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      onPressed: () => _loginGoogle(context, loginBloc),
      elevation: 4.0,
      child: Container(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                  alignment: Alignment.center,
                  child: Container(
                      child: Image(image: AssetImage('assets/google.png')))),
            ),
            Expanded(
              flex: 5,
              child: Container(
                alignment: Alignment.center,
                child: Text('Log in con Google',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w400)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createAccountLabel(BuildContext context, LoginBloc loginBloc) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacementNamed(context, 'register');
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'No tienes Cuenta ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Registrate',
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

  void _mostrarAlerta(BuildContext context, String text, String subtext) {
    showDialog(
        context: context,
        child: AlertDialog(
          elevation: 2.0,
          content: Text(subtext),
          title: Text(
            text,
            style: TextStyle(fontSize: 20.0),
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () => Navigator.of(context).pop(), child: Text('Ok'))
          ],
        ));
  }

  _loginGoogle(BuildContext context, LoginBloc loginBloc) async {
    // final user = await loginBloc.loginWithGoogle();
    // print(user);
    _mostrarAlerta(context, 'Proximamente', 'Estamos trabajando para ti');
  }
}
