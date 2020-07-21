import 'package:cloud_firestore/cloud_firestore.dart';

class Servicios {
  List<Servicio> items = new List();
  Servicios.fromJsonList(List<DocumentSnapshot> servicios) {
    if (servicios == null) return;
    for (var item in servicios) {
      final servicio = new Servicio.fromJsonMap(item.data, item.documentID);
      items.add(servicio);
    }
  }
}

class Servicio {
  String id;
  String categoria;
  bool disponibilidad;
  String idUsuario;
  String nombre;
  String descripcion;
  double puntaje;
  List evidencia;
  Servicio(
      {this.nombre,
      this.disponibilidad = true,
      this.categoria,
      this.idUsuario,
      this.evidencia,
      this.descripcion});
  Servicio.fromJsonMap(Map<String, dynamic> json, String id) {
    this.id = id;
    this.nombre = json['nombre'];
    this.categoria = json['categoria'];
    this.disponibilidad = json['disponibilidad'];
    this.idUsuario = json['id-usuario'];
    this.descripcion = json['descripcion'];
    this.evidencia = json['evidencia'];
  }
}
