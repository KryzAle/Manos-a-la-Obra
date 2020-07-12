import 'package:flutter/material.dart';
import 'package:manos_a_la_obra/src/bloc/login_bloc.dart';
import 'package:manos_a_la_obra/src/bloc/provider.dart';

class CambiarPasswordPage extends StatefulWidget {
  @override
  _CambiarPasswordPageState createState() => _CambiarPasswordPageState();
}

class _CambiarPasswordPageState extends State<CambiarPasswordPage> {
 final formkey = GlobalKey<FormState>();
  Widget build(BuildContext context) {
  final loginBloc = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cambiar Contraseña',style: TextStyle(color: Colors.white),),
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
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: <Widget>[
              _crearInputPassword(loginBloc),
              _crearInputConfirmPassword(loginBloc),
              Expanded(child: Container()),
              _crearBotonActualizar(loginBloc),
            ],
          ),
        )
      )
    );
  }

  Widget _crearInputPassword(LoginBloc loginBloc) {
    return StreamBuilder(
      stream: loginBloc.passwordStream,
      initialData:'',
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 30.0),
          child: TextFormField(
            obscureText: true,
            initialValue: snapshot.data,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              errorText: snapshot.error,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelStyle: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold
              ),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              loginBloc.changePassword(value);
            },
          ),
        );
      }
    );
  }

  Widget _crearInputConfirmPassword(LoginBloc loginBloc) {
        return Container(
          margin: EdgeInsets.symmetric(vertical:10.0),
          child: TextFormField(
            obscureText: true,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Confirmar Contraseña',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelStyle: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold
              ),
              border: OutlineInputBorder(),
            ),
            validator: (value){
              if(value != loginBloc.password){
                return 'La contraseña de verificación no coincide';
              }else{
                return null;
              }
            },
          ),
        );
  }

  Widget _crearBotonActualizar(LoginBloc loginBloc) {
    return Container(
      padding: EdgeInsets.all(10.0),
      width: double.infinity,
      child: RaisedButton(
        padding: EdgeInsets.all(15.0),
        onPressed: ()=>_submit(loginBloc),
        child: Container(
          child: Text('Cambiar Contraseña', textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 17.0),)
        ),
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
          side: BorderSide(color: Colors.orangeAccent),
        ),
        color: Colors.orangeAccent,
      ),
    );
  }

  void _submit(LoginBloc loginBloc) async{
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
    await loginBloc.cambiarPassword();
    await  Future.delayed(const Duration(seconds: 1));
    loginBloc.resetValues();
    Navigator.pop(context);
    Navigator.pop(context);
  }

}