import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manos_a_la_obra/src/bloc/categoria_servicio_bloc.dart';
import 'package:manos_a_la_obra/src/bloc/login_bloc.dart';
import 'package:manos_a_la_obra/src/bloc/provider.dart';
import 'package:manos_a_la_obra/src/providers/usuario_provider.dart';
import 'package:manos_a_la_obra/src/routes/routes.dart';

void main() {
  runApp(MyApp());
} 
  
 
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final loginBloc  = new LoginBloc();
  String ruta = 'welcome';

  @override
  void initState() {
    cargarUsuario();
    super.initState();
  }
  void cargarUsuario() async{
    loginBloc.cargando(true);
    final user = await loginBloc.isLogin();
    ruta = user ? 'home' : 'welcome';
    loginBloc.cargando(false);
  }
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Provider(
      child: StreamBuilder(
        stream: loginBloc.cargandoStream ,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            if(!snapshot.data ){ 
              final categoria = Provider.categoria(context);
              final servicios = Provider.servicio(context);
              servicios.cargarServicios();
              categoria.cargarCategoria();
              return MaterialApp( 
                theme: ThemeData(
                primaryColor: Colors.orangeAccent ,
                primarySwatch: Colors.orange,
                textTheme:GoogleFonts.latoTextTheme(textTheme).copyWith(
                  bodyText1: GoogleFonts.montserrat(textStyle: textTheme.bodyText1),
                ),
              ),
              title: 'Material App',
              debugShowCheckedModeBanner: false,
              initialRoute: ruta,
              routes: getAplicationRoutes(),
              );
          }
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}