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
  String direccion;
  Timestamp fechaInicio;
  Timestamp fechaFin;
  String idCliente;
  String idServicio;
  bool terminado;
  Solicitud({
    this.aceptado = false,
    this.descripcion,
    this.direccion,
    this.fechaInicio,
    this.fechaFin,
    this.idCliente,
    this.idServicio,
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
    this.idServicio = json['id-servicio'];
    this.terminado = json['terminado'];
  }
}
