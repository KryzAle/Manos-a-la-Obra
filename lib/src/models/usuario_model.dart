
class Usuario {
  String foto;
  String nombre;
  String cedula;
  bool proveedor;
  Usuario.fromMap(Map<String, dynamic> data) {
    this.foto = data['foto'];
    this.nombre = data['nombre'];
    this.cedula = data['cedula'];
    this.proveedor = data['proveedor'];
  }
}
