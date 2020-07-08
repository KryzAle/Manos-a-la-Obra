class CategoriasServicios{
  List<CategoriaServicio> items = new List();
  CategoriasServicios({this.items});
  CategoriasServicios.fromJsonList(List<dynamic> categorias){
    if(categorias==null) return;
    for (var item in categorias) {
      final categoria = new CategoriaServicio.fromJsonMap(item.data);
      items.add(categoria);
    }
  }
  
}
class CategoriaServicio {
  String id;
  String nombre;
  String icon;
  String color;
  CategoriaServicio({
    this.nombre,
    this.icon,
    this.color,
  });
  CategoriaServicio.fromJsonMap(Map<String,dynamic> json){
    this.nombre = json['nombre'];
    this.icon = json['icon'];
    this.color = json['color'];
    this.id = json['id'];
  }
}