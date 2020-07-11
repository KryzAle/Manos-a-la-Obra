
class Usuario {
  String foto;
  String nombre;
  String cedula;
  String telefono;
  bool   proveedor;
  Usuario({this.foto,this.nombre,this.cedula,this.proveedor,this.telefono});
  Usuario.fromMap(Map<String, dynamic> data) {
    this.foto = data['foto'] != null ?data['foto']:'';
    this.nombre = data['nombre']!= null ?data['nombre']:'';
    this.cedula = data['cedula']!= null ?data['cedula']:'';
    this.telefono = data['telefono']!= null ?data['telefono']:'';
    this.proveedor = data['proveedor']!= null ?data['proveedor']:false;
  }
}
