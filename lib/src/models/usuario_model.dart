
import 'package:manos_a_la_obra/src/models/puntuacion_model.dart';

class Servicio {
  String cedula;
  String foto;
  String nombre;
  bool proveedor;
  List<Puntuacion> puntaciones;
  Servicio({
    this.nombre,
    this.cedula,
    this.foto,
    this.proveedor,
  });
  Servicio.fromJsonMap(Map<String,dynamic> json,List<Puntuacion> puntuaciones){
    this.nombre = json['nombre'];
    this.cedula = json['cedula'];
    this.foto = json['foto'];
    this.proveedor = json['proveedor'];
    this.puntaciones = puntuaciones;
  }
}