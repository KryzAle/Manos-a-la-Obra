import 'package:cloud_firestore/cloud_firestore.dart';

class Puntuaciones{

  List<Puntuacion> items = new List();
  Puntuaciones.fromJsonList(List<DocumentSnapshot> puntuaciones){
    if(puntuaciones==null) return;
    for (var item in puntuaciones) {
      final puntuacion = new Puntuacion.fromJsonMap(item.data);
      items.add(puntuacion);
    }
  }
  
}
class Puntuacion {
  String comentario;
  double valor;
  Puntuacion({
    this.comentario,
    this.valor,
  });
  Puntuacion.fromJsonMap(Map<String,dynamic> json){
    this.valor      = json['valor']/1;
    this.comentario = json['comentario'];
  }
}