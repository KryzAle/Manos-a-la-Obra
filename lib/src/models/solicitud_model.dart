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
  bool revisado;
  String descripcion;
  Map<String, dynamic> direccion;
  Timestamp fechaSolicitud;
  Timestamp fechaInicio;
  Timestamp fechaFin;
  String idCliente;
  String idProveedor;
  String idServicio;
  Map<String, dynamic> cliente;
  Map<String, dynamic> servicio;

  bool terminado;
  bool cancelado;

  Solicitud({
    this.aceptado = false,
    this.revisado = false,
    this.descripcion,
    this.direccion,
    this.fechaSolicitud,
    this.fechaInicio,
    this.fechaFin,
    this.idCliente,
    this.idProveedor,
    this.idServicio,
    this.cliente,
    this.servicio,
    this.terminado = false,
    this.cancelado = false,
  });
  Solicitud.fromJsonMap(Map<String, dynamic> json, String id) {
    this.id = id;
    this.aceptado = json['aceptado'];
    this.descripcion = json['descripcion'];
    this.direccion = json['direccion'];
    this.fechaSolicitud = json['fechaSolicitud'];
    this.fechaInicio = json['fechaInicio'];
    this.fechaFin = json['fechaFin'];
    this.idCliente = json['id-cliente'];
    this.idProveedor = json['id-cliente'];
    this.idServicio = json['id-servicio'];
    this.cliente = json['cliente'];
    this.servicio = json['servicio'];
    this.terminado = json['terminado'];
    this.cancelado = json['cancelado'];
  }
}
