class Servicios {
  List<Servicio> items = new List();
  Servicios.fromList(List<dynamic> servicios) {
    if (servicios == null) return;
    for (var item in servicios) {
      final servicio = new Servicio.fromMap(item.data);
      items.add(servicio);
    }
  }
}

class Servicio {
  String id;
  String categoria;
  bool disponibilidad;
  List evidencia;
  String idUsuario;
  String nombre;
  String descripcion;
  double puntaje;
  Servicio({
    this.id,
    this.categoria,
    this.disponibilidad = true,
    this.evidencia,
    this.idUsuario,
    this.nombre,
    this.descripcion,
    this.puntaje,
  });
  Servicio.fromMap(Map<String, dynamic> data) {
    this.categoria = data['categoria'];
    this.disponibilidad = data['disponibilidad'];
    this.evidencia = data['evidencia'];
    this.idUsuario = data['idUsuario'];
    this.nombre = data['nombre'];
    this.descripcion = data['descripcion'];
  }
}
