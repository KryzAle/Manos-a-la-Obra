import 'package:flutter/material.dart';
import 'package:manos_a_la_obra/src/bloc/provider.dart';
import 'package:manos_a_la_obra/src/models/servicio_model.dart';
import 'package:manos_a_la_obra/src/pages/detalle_servicio_page.dart';
import 'package:manos_a_la_obra/src/pages/register_solicitudes_page.dart';
import 'package:manos_a_la_obra/src/pages/solicitar_servicio_page.dart';

class ServiciosSearch extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Que necesitas?';

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro AppBar
    return <Widget>[
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar
    return Text('s');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final _servicioProvider = Provider.servicio(context);
    // Son las sugerencias que aparecen cuando escriben
    if (query.isEmpty) {
      return Container();
    } else {
      return StreamBuilder(
        stream: _servicioProvider.getServicios,
        builder:
            (BuildContext context, AsyncSnapshot<List<Servicio>> snapshot) {
          if (snapshot.hasData) {
            final servicios = snapshot.data;
            return ListView(
                children: servicios.map((servicio) {
              if (servicio.nombre.toLowerCase().contains(query.toLowerCase())) {
                return ListTile(
                  title: Text(
                    servicio.nombre.toUpperCase(),
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  subtitle: Row(
                    children: _crearPuntaje(servicio.puntaje),
                  ),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://www.christiangarces.org/wp-content/uploads/2017/11/perfil-profesional.jpg'),
                  ),
                  trailing: Icon(Icons.arrow_right),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetalleServicio(
                            categoria: servicio.categoria,
                            descripcion: servicio.descripcion,
                            nombre: servicio.nombre,
                            disponibilidad: servicio.disponibilidad,
                            path: servicio.evidencia,
                            puntajes: servicio.puntaje,
                            idServicio: servicio.id,
                          ),
                        ));
                  },
                );
              }
              return Container();
            }).toList());
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    }
  }

  List<Widget> _crearPuntaje(double starts) {
    final widgets = <Widget>[];
    int numeroStrella = starts.toInt();
    if (numeroStrella > 0) {
      for (var i = 0; i < numeroStrella; i++) {
        widgets.add(Icon(
          Icons.star,
          color: Colors.orangeAccent,
        ));
      }
      widgets.add(starts - numeroStrella != 0
          ? Icon(
              Icons.star_half,
              color: Colors.orangeAccent,
            )
          : null);
    } else {
      widgets.add(Text('Sin Puntuacion'));
    }
    return widgets;
  }
}
