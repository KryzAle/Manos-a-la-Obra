import 'package:flutter/material.dart';
import 'package:manos_a_la_obra/src/pages/cambiar_password_page.dart';

import 'package:manos_a_la_obra/src/pages/editar_perfil_page.dart';
import 'package:manos_a_la_obra/src/pages/home_page.dart';
import 'package:manos_a_la_obra/src/pages/login_page.dart';
import 'package:manos_a_la_obra/src/pages/mi_perfil_page.dart';
import 'package:manos_a_la_obra/src/pages/mis_servicios_page.dart';
import 'package:manos_a_la_obra/src/pages/register_page.dart';
import 'package:manos_a_la_obra/src/pages/register_solicitudes_page.dart';
import 'package:manos_a_la_obra/src/pages/solicitudes_page.dart';
import 'package:manos_a_la_obra/src/pages/welcome_page.dart';

Map<String, WidgetBuilder> getAplicationRoutes() {
  return <String, WidgetBuilder>{
    'welcome': (BuildContext context) => WelcomePage(),
    'login': (BuildContext context) => LoginPage(),
    'home': (BuildContext context) => HomePage(),
    'register': (BuildContext context) => RegisterPage(),
    'register_solicitudes': (BuildContext context) => RegisterSolicitudesPage(),
    'solicitudes': (BuildContext context) => SolicitudesPage(),
    'perfil': (BuildContext context) => MiPerfilPage(),
    'editar_perfil': (BuildContext context) => EditarPerfilPage(),
    'cambiar_password': (BuildContext context) => CambiarPasswordPage(),
    'mis_servicios': (BuildContext context) => MisServiciosPage(),
  };
}
