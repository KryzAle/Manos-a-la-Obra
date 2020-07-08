import 'package:flutter/material.dart';

import 'package:manos_a_la_obra/src/pages/home_page.dart';
import 'package:manos_a_la_obra/src/pages/login_page.dart';
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
  };
}
