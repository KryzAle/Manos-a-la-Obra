import 'package:flutter/material.dart';
import 'package:manos_a_la_obra/src/bloc/categoria_servicio_bloc.dart';
import 'package:manos_a_la_obra/src/bloc/direccion_bloc.dart';
import 'package:manos_a_la_obra/src/bloc/login_bloc.dart';
import 'package:manos_a_la_obra/src/bloc/servicio_bloc.dart';
import 'package:manos_a_la_obra/src/bloc/solicitud_bloc.dart';
import 'package:manos_a_la_obra/src/bloc/usuario_bloc.dart';

class Provider extends InheritedWidget {
  final loginBloc = LoginBloc();
  final categoriaBloc = CategoriaBloc();
  final servicioBloc = ServicioBloc();
  final usuarioBloc = UsuarioBloc();
  final direccionBloc = DireccionBloc();
  final solicitudBloc = SolicitudBloc();


  static Provider _instancia;

  factory Provider({Key key, Widget child}) {
    if (_instancia == null) {
      _instancia = new Provider._internal(key: key, child: child);
    }
    return _instancia;
  }

  Provider._internal({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }

  static CategoriaBloc categoria(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().categoriaBloc;
  }

  static ServicioBloc servicio(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().servicioBloc;
  }

  static UsuarioBloc usuario(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().usuarioBloc;
  }

  static DireccionBloc direccion(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().direccionBloc;
  }
  static SolicitudBloc solicitud(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().solicitudBloc;
  }
}
