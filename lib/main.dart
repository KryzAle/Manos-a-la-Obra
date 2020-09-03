import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manos_a_la_obra/src/bloc/login_bloc.dart';
import 'package:manos_a_la_obra/src/bloc/provider.dart';
import 'package:manos_a_la_obra/src/providers/push_notification_provider.dart';
import 'package:manos_a_la_obra/src/routes/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final loginBloc = new LoginBloc();
  String ruta = 'welcome';
  bool autenticado = false;
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  @override
  void initState() {
    cargarUsuario();

    super.initState();
    final pushProvider = new PushNotificationProvider();
    pushProvider.initNotifications();
    pushProvider.mensajeStream.listen((event) {
      print(event);
      if (event != null) {
        navigatorKey.currentState.pushNamed(event);
      }
    });
  }

  void cargarUsuario() async {
    loginBloc.cargando(true);
    final user = await loginBloc.isLogin();
    if (user) {
      ruta = 'home';
      autenticado = true;
    } else {
      ruta = 'welcome';
    }
    loginBloc.cargando(false);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Provider(
      child: StreamBuilder(
        stream: loginBloc.cargandoStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (!snapshot.data) {
              final categoriaBloc = Provider.categoria(context);
              final serviciosBloc = Provider.servicio(context);
              final usuarioBloc = Provider.usuario(context);
              final direccionBloc = Provider.direccion(context);
              final solicitudesBloc = Provider.solicitud(context);
              serviciosBloc.cargarServicios();
              categoriaBloc.cargarCategoria();
              if (autenticado) {
                usuarioBloc.cargarUsuario();
                direccionBloc.cargarDireccionUsuario();
                serviciosBloc.cargarServiciosUsuario();
                solicitudesBloc.cargarMisSolicitudesActivas();
                solicitudesBloc.cargarSolicitudesUsuario();
                solicitudesBloc.cargarNuevasSolicitudesUsuario();
              }
              return MaterialApp(
                navigatorKey: navigatorKey,
                theme: ThemeData(
                  primaryColor: Colors.orangeAccent,
                  primarySwatch: Colors.orange,
                  textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
                    bodyText1:
                        GoogleFonts.montserrat(textStyle: textTheme.bodyText1),
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
