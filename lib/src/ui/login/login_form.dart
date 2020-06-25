import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manos_a_la_obra/src/bloc/login_bloc/bloc.dart';
import 'package:manos_a_la_obra/src/bloc/authentication_bloc/bloc.dart';
import 'package:manos_a_la_obra/src/repository/user_repository.dart';
import 'package:manos_a_la_obra/src/ui/login/create_account_button.dart';
import 'package:manos_a_la_obra/src/ui/login/google_login_button.dart';
import 'package:manos_a_la_obra/src/ui/login/login_button.dart';
import 'package:manos_a_la_obra/src/ui/welcome_screen.dart';
import 'package:manos_a_la_obra/src/ui/widgets/bezierContainer.dart';

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;

  LoginForm({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }
  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

 

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return BlocListener<LoginBloc, LoginState>(listener: (context, state) {
      // tres casos, tres if:
      if (state.isFailure) {
        Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('Inicio de Sesión Fallido'), Icon(Icons.error)],
              ),
              backgroundColor: Colors.red,
            ),
          );
      }
      if (state.isSubmitting) {
        Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Iniciando Sesión... '),
                CircularProgressIndicator(),
              ],
            ),
          ));
      }
      if (state.isSuccess) {
        BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        Navigator.pop(context);
      }
    }, child: BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Scaffold(
            body: Container(
              height : height,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: -height * .15,
                    right: -MediaQuery.of(context).size.width * .4,
                    child: BezierContainer()
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: height * .2),
                          //title
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
                                    text: 'Iniciar Sesión',
                                    style: TextStyle(color: Colors.black, fontSize: 30),
                                  ),
                                ]),
                          ),
                          
                          SizedBox(height: 50),
                          //emailpasswordwidget
                          Column(
                            children: <Widget>[
                                //entryfield email
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    icon: Icon(Icons.email),
                                    labelText: 'Email'
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  autovalidate: true,
                                  autocorrect: false,
                                  validator: (_){
                                    return !state.isEmailValid? 'Invalid Email': null;
                                  },
                                ),
                              ),
                              SizedBox(height: 20),
                              //entryfieldpassword

                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: TextFormField(
                                      controller: _passwordController,
                                      decoration: InputDecoration(
                                        icon: Icon(Icons.lock),
                                        labelText: 'Contraseña'
                                      ),
                                      obscureText: true,
                                      autovalidate: true,
                                      autocorrect: false,
                                      validator: (_){
                                        return !state.isPasswordValid? 'Contraseña Invalida, asegurese de usar letras y numeros': null;
                                      },
                                    ),
                              ),

                              SizedBox(height: 20),
                            ],
                          ),
                          SizedBox(height: 20),
                          LoginButton(
                            onPressed: isLoginButtonEnabled(state)
                            ? _onFormSubmitted
                            : null,
                          ),
                          
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.centerRight,
                            child: Text('Olvidaste tu contraseña ?',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500)),
                          ),
                          
                          Container(
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
                                Text('O'),
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
                          ),
                          GoogleLoginButton(),
                          SizedBox(height: height * .055),
                          
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => WelcomePage(userRepository: _userRepository,)));
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 20),
                              padding: EdgeInsets.all(15),
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'No tienes una cuenta?',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  CreateAccountButton(userRepository: _userRepository,),
                                ],
                              ),
                            ),
                          ), 
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        );
      },
    ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _loginBloc.add(EmailChanged(email: _emailController.text));
  }

  void _onPasswordChanged() {
    _loginBloc.add(PasswordChanged(password: _passwordController.text));
  }

  void _onFormSubmitted() {
    _loginBloc.add(
      LoginWithCredentialsPressed(
        email: _emailController.text,
        password: _passwordController.text
      )
    );
  }
}
