import 'dart:async';
import 'dart:io';

import 'package:manos_a_la_obra/src/models/servicio_model.dart';
import 'package:manos_a_la_obra/src/providers/servicio_provider.dart';
import 'package:manos_a_la_obra/src/providers/user_data_provider.dart';
import 'package:manos_a_la_obra/src/providers/usuario_provider.dart';
import 'package:rxdart/rxdart.dart';

class ServicioBloc {
  List<Servicio> _filtrado = List<Servicio>();
  String _categoria = '';
  final puntuacionProvider = new UsuarioProvider();
  final usuarioProvider = new UserDataProvider();
  final servicioProvider = ServicioDataProvider();
  final _serviciosController = BehaviorSubject<List<Servicio>>();
  final _serviciosSearchController = BehaviorSubject<List<Servicio>>();
  final _serviciosUsuarioController = BehaviorSubject<List<Servicio>>();

  //escuchar stream
  Stream<List<Servicio>> get getServicios => _serviciosController.stream;
  Stream<List<Servicio>> get getServiciosSearch => _serviciosSearchController.stream;
  Stream<List<Servicio>> get getServiciosUsuario =>
      _serviciosUsuarioController.stream;

  //agregar stream
  Function(List<Servicio>) get changeServicio => _serviciosController.sink.add;
  Function(List<Servicio>) get changeServicioSearch => _serviciosSearchController.sink.add;
  Function(List<Servicio>) get changeServicioUsuario =>
      _serviciosUsuarioController.sink.add;

  List<Servicio> get servicios => _serviciosController.value;

  void dispose() {
    _serviciosController?.close();
    _serviciosSearchController?.close();
    _serviciosUsuarioController?.close();
  }

  void cargarServicios() {
    final subscriptionServicio = servicioProvider.getServicios();
    subscriptionServicio.listen((event) async {
      final servicios = new List<Servicio>();
      for (var item in event.documents) {
        double puntaje = 0;
        final servicio = Servicio.fromJsonMap(item.data, item.documentID);
        final puntuaciones =
            await puntuacionProvider.puntaje(servicio.idUsuario);
        if (puntuaciones != null) {
          for (var puntuacion in puntuaciones) {
            puntaje += puntuacion.valor;
          }
          puntaje /= puntuaciones.length;
        }
        servicio.puntaje = puntaje;
        servicios.add(servicio);
      }
      changeServicio(servicios);
      filtrarServiciosCategoria(_categoria);
    });
  }
  void filtrarServiciosCategoria(String categoria)async{
    _categoria = categoria;
    _filtrado = List<Servicio>();
    if(_serviciosController.hasValue){
      for (var value in servicios) {
        if (value.categoria == _categoria) {
          _filtrado.add(value);
        }else{
          if(categoria =='todos'){
            _filtrado.add(value);
          }
        }
      }
      changeServicioSearch(_filtrado);
    }
    
  }
  void filtrarServiciosQuery(String query){
    final _filtro = List<Servicio>();
    if(query!=''){
      for (var value in _filtrado) {
        if (value.nombre.toLowerCase().contains(query.toLowerCase())) {
          _filtro.add(value);
        }
      }
      changeServicioSearch(_filtro);
    }else{
      changeServicioSearch(_filtrado);
    }
  }
  void filtrarServiciosFiltros(String filtros){
    List<Servicio> _filtro = List<Servicio>();
    if(filtros!=''){
      switch (filtros) {
        case 'puntuacion':
          print('fitrando por puntuacion');
          
          break;
        case 'popularidad':
          print('fitrando por polaridad');
          _filtro = _filtrado;
          _filtro.sort((a,b){
            return b.nombre.toLowerCase().compareTo(a.nombre.toLowerCase());
          });
          break;
        case 'disponibilidad':
          print('fitrando por disponibilidad');

          for (var value in _filtrado) {
            if (value.disponibilidad==true) {
              _filtro.add(value);
            }
          }
          break;
        default:
      }
      
      changeServicioSearch(_filtro);
    }else{
      changeServicioSearch(_filtrado);
    }
  }

  void cargarServiciosUsuario() {
    usuarioProvider.getIdCurrentUser().then((value) {
      final subscriptionServicio = servicioProvider.getServiciosUsuario(value);
      subscriptionServicio.listen((event) {
        final servicios = new List<Servicio>();
        for (var item in event.documents) {
          final servicio = Servicio.fromJsonMap(item.data, item.documentID);
          servicios.add(servicio);
        }
        changeServicioUsuario(servicios);
      });
    });
  }

  Future<void> insertarServicio(
      Servicio dataservicio, String idUsuario, List<File> imagenes) async {
    final listaPaths = List();
    for (var imagen in imagenes) {
      final path = await servicioProvider.guardarImageServicio(imagen);
      listaPaths.add(path);
    }
    dataservicio.evidencia = listaPaths;
    await servicioProvider.loadServicio("servicio", dataservicio, idUsuario);
  }
}
