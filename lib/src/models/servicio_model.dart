import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:manos_a_la_obra/src/models/categoria_servicio_model.dart';

class Servicios{

  List<Servicio> items = new List();
  Servicios.fromJsonList(List<DocumentSnapshot> servicios){
    if(servicios==null) return;
    for (var item in servicios) {
      final servicio = new Servicio.fromJsonMap(item.data, item.documentID);
      items.add(servicio);
    }
  }
  
}
class Servicio {
  String id;
  CategoriaServicio categoria ;
  bool disponibilidad;
  String idUsuario;
  String nombre;
  double puntaje;
  List evidencia;
  Servicio({
    this.nombre,
    this.disponibilidad,
    this.categoria,
    this.idUsuario,
    this.evidencia,
  });
  Servicio.fromJsonMap(Map<String,dynamic> json,String id){
    this.id = id;
    this.nombre = json['nombre'];
    this.disponibilidad = json['disponibilidad'];
    this.idUsuario = json['id-usuario'];
  }
}