import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manos_a_la_obra/src/bloc/login_bloc.dart';
import 'package:manos_a_la_obra/src/bloc/provider.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginBloc = Provider.of(context);
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
                    SizedBox(height: height * .14),
                    _loginAccountLabel(context),
                  ],
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

  Widget _mailField(loginBloc) {
    return StreamBuilder(
      stream: loginBloc.emailStream,
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

  Widget _submitButton(BuildContext context, LoginBloc loginBloc) {
    return StreamBuilder(
      stream: loginBloc.formValidStream,
      initialData: '',
      builder: (BuildContext context, AsyncSnapshot snapshot) {
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
          onPressed:
              snapshot.hasData ? () => _register(context, loginBloc) : null,
        );
      },
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
    final usuarioBloc = Provider.usuario(context);
    if (await loginBloc.register()) {
      usuarioBloc.cargarUsuario();
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      _mostrarAlerta(context, 'Datos Incorrectos',
          'Email invalido o se encuentra registrado');
    }
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
}
