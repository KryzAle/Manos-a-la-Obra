import 'package:cloud_firestore/cloud_firestore.dart';

class Solicitudes {
  List<Solicitud> items = new List();
  Solicitudes.fromJsonList(List<DocumentSnapshot> solicitudes) {
    if (solicitudes == null) return;
    for (var item in solicitudes) {
      final solicitud = new Solicitud.fromJsonMap(item.data, item.documentID);
      items.add(solicitud);
    }
  }
}

class Solicitud {
  String id;
  bool aceptado;
  String descripcion;
  Map<String, dynamic> direccion;
  Timestamp fechaInicio;
  Timestamp fechaFin;
  String idCliente;
  String idProveedor;
  String idServicio;
  Map<String, dynamic> servicio;

  bool terminado;
  Solicitud({
    this.aceptado = false,
    this.descripcion,
    this.direccion,
    this.fechaInicio,
    this.fechaFin,
    this.idCliente,
    this.idProveedor,
    this.idServicio,
    this.servicio,
    this.terminado = false,
  });
  Solicitud.fromJsonMap(Map<String, dynamic> json, String id) {
    this.id = id;
    this.aceptado = json['aceptado'];
    this.descripcion = json['descripcion'];
    this.direccion = json['direccion'];
    this.fechaInicio = json['fechaInicio'];
    this.fechaFin = json['fechaFin'];
    this.idCliente = json['id-cliente'];
    this.idProveedor = json['id-cliente'];
    this.idServicio = json['id-servicio'];
    this.servicio = json['servicio'];
    this.terminado = json['terminado'];
  }
}
