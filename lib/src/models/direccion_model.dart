import 'package:cloud_firestore/cloud_firestore.dart';

class Direcciones {
  List<Direccion> items = new List();
  Direcciones.fromJsonList(List<DocumentSnapshot> direcciones) {
    if (direcciones == null) return;
    for (var item in direcciones) {
      final direccion = new Direccion.fromJsonMap(item.data, item.documentID);
      items.add(direccion);
    }
  }
}

class Direccion {
  String id;
  String nombre;
  String ubicacionMap;
  String callePrincipal;
  String numeroVivienda;
  String calleSecundaria;
  String referencia;
  double latitud;
  double longitud;
  Direccion(
      {
        this.id,
        this.nombre='',
        this.callePrincipal='',
        this.numeroVivienda='',
        this.calleSecundaria='',
        this.referencia='',
        this.ubicacionMap='',
        this.latitud,
        this.longitud,
      });
  Direccion.clone(Direccion direccion){
        this.id=direccion.id;
        this.nombre=direccion.nombre;
        this.callePrincipal=direccion.callePrincipal;
        this.numeroVivienda=direccion.numeroVivienda;
        this.calleSecundaria=direccion.calleSecundaria;
        this.ubicacionMap = direccion.ubicacionMap;
        this.referencia=direccion.referencia;
        this.latitud=direccion.latitud;
        this.longitud=direccion.longitud;
  }
  Direccion.fromJsonMap(Map<String, dynamic> json, String id) {
    this.id = id;
    this.nombre = json['nombre'];
    this.callePrincipal = json['callePrincipal'];
    this.numeroVivienda = json['numeroVivienda'];
    this.calleSecundaria = json['calleSecundaria'];
    this.ubicacionMap = json['ubicacionMap'];
    this.referencia = json['referencia'];
    this.latitud = json['latitud'];
    this.longitud = json['longitud'];
  }
}
