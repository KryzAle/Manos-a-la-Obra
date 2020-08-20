import 'package:flutter/material.dart';
import 'package:manos_a_la_obra/src/models/servicio_model.dart';
import 'package:manos_a_la_obra/src/providers/solicitud_provider.dart';


class TarjetaServiciosSearch extends StatefulWidget {
  final Servicio servicio;
  final Function funcion;

  TarjetaServiciosSearch({@required this.servicio,@required this.funcion});

  @override
  _TarjetaServiciosSearchState createState() => _TarjetaServiciosSearchState();
}

class _TarjetaServiciosSearchState extends State<TarjetaServiciosSearch> {
  final providerSolicitud = SolicitudDataProvider();
  String imgUrl;

  @override
  Widget build(BuildContext context) {
    _obtenerUrlImagen(widget.servicio.evidencia[0]);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          widget.funcion();
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                offset: const Offset(4, 4),
                blurRadius: 16,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 3,
                      child: imgUrl != null
                          ? Image.network(
                              imgUrl,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              child: CircularProgressIndicator(),
                              alignment: Alignment.center,
                            ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, top: 8, bottom: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      widget.servicio.nombre,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Row(
                                      children: _crearPuntaje(widget.servicio.puntaje),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _obtenerUrlImagen(path) async {
    final providerSolicitud = SolicitudDataProvider();
    final fileURL = await providerSolicitud.getImageUserSolicitud(path);
    if (this.mounted) {
      setState(() {
        imgUrl = fileURL;
      });
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
          : Container());
    } else {
      widgets.add(Text('Sin Puntuacion'));
    }
    return widgets;
  }
}