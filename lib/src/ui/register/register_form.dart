import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manos_a_la_obra/src/bloc/register_bloc/bloc.dart';
import 'package:manos_a_la_obra/src/bloc/authentication_bloc/bloc.dart';
import 'package:manos_a_la_obra/src/ui/register/register_button.dart';
import 'package:manos_a_la_obra/src/ui/widgets/bezierContainer.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  // Dos variables
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  RegisterBloc _registerBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
  
  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        // Si estado es submitting
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Registrando..'),
                    CircularProgressIndicator()
                  ],
                ),
              )
            );
        }
        // Si estado es success
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context)
            .add(LoggedIn());
            Navigator.pop(context);
        }
        // Si estado es failure
        if (state.isFailure) {
          Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Registro Fallido'),
                  Icon(Icons.error)
                ],
              ),
              backgroundColor: Colors.red,
            )
          );
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          return Scaffold(
            body: Container(
              height: height,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: -MediaQuery.of(context).size.height * .15,
                    right: -MediaQuery.of(context).size.width * .4,
                    child: BezierContainer(),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: height * .2),
                          
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              
                              style: GoogleFonts.portLligatSans(
                                textStyle: Theme.of(context).textTheme.headline4,
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: Color(0xffe46b10),
                              ),
                              children: [
                                TextSpan(
                                  text: 'Crear una nueva cuenta',
                                  style: TextStyle(color: Colors.black, fontSize: 30),
                                ),
                              ]
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child:TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    icon: Icon(Icons.email),
                                    labelText: 'Correo Electrónico',
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  autocorrect: false,
                                  autovalidate: true,
                                  validator: (_){
                                    return !state.isEmailValid? 'Email Invalido' : null;
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child:TextFormField(
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.lock),
                                    labelText: 'Contraseña'
                                  ),
                                  obscureText: true,
                                  autocorrect: false,
                                  autovalidate: true,
                                  validator: (_){
                                    return !state.isPasswordValid ? 'Contraseña Invalida': null;
                                  },
                                ),
                              ),  
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          
                          RegisterButton(
                            onPressed: isRegisterButtonEnabled(state)
                              ? _onFormSubmitted
                              : null,
                          ),


                          SizedBox(height: height * .14),
                          //_loginAccountLabel(),
                        ],
                      ),
                    ),
                  ),
                  //Positioned(top: 40, left: 0, child: _backButton()),
                ],
              ),
            ),
          );
        },
      )
    );
  }

  void _onEmailChanged() {
    _registerBloc.add(
      EmailChanged(email: _emailController.text)
    );
  }

  void _onPasswordChanged() {
    _registerBloc.add(
      PasswordChanged(password: _passwordController.text)
    );
  }

  void _onFormSubmitted() {
    _registerBloc.add(
      Submitted(
        email: _emailController.text,
        password: _passwordController.text
      )
    );
  }
}
