
class Usuario {
  String foto;
  String fotoUrl;
  String nombre;
  String cedula;
  String telefono;
  bool   proveedor;
  String  token_dispositivo;
  Usuario({this.foto,this.nombre,this.cedula,this.proveedor,this.telefono});
  Usuario.fromMap(Map<String, dynamic> data) {
    this.foto = data['foto'] != null ?data['foto']:'';
    this.foto = data['token_dispositivo'] != null ?data['token_dispositivo']:'';
    this.nombre = data['nombre']!= null ?data['nombre']:'';
    this.cedula = data['cedula']!= null ?data['cedula']:'';
    this.telefono = data['telefono']!= null ?data['telefono']:'';
    this.proveedor = data['proveedor']!= null ?data['proveedor']:false;
  }
  String getFoto(){
    return 'https://kryzale.files.wordpress.com/2019/03/10928983_1386324075004590_3936503588471348202_n.jpg?w=960&h=730&crop=1';
  }
}
