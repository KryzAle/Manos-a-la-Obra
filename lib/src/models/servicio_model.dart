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
  String nombre;
  String descripcion;
  double puntaje;
  List evidencia;
  Timestamp fechaCreacion;
  Timestamp fechaModificacion;
  int popularidad;
  double valoracionTotal;
  Map<String, dynamic> usuario;
  Servicio(
      {this.nombre,
      this.disponibilidad = true,
      this.categoria,
      this.evidencia,
      this.descripcion,
      this.fechaCreacion,
      this.fechaModificacion,
      this.popularidad = 0,
      this.valoracionTotal = 0,
      this.usuario});
  Servicio.fromJsonMap(Map<String, dynamic> json, String id) {
    this.id = id;
    this.nombre = json['nombre'];
    this.categoria = json['categoria'];
    this.disponibilidad = json['disponibilidad'];
    this.descripcion = json['descripcion'];
    this.evidencia = json['evidencia'];
    this.fechaCreacion = json['fechaCreacion'];
    this.fechaModificacion = json['fechaModificacion'];
    this.popularidad = json['popuparidad'];
    this.valoracionTotal = json['valoracionTotal']/1;
    this.usuario = json['usuario'];
  }
}
