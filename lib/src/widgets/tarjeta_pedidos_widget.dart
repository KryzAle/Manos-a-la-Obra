import 'package:flutter/material.dart';
import 'package:manos_a_la_obra/src/providers/servicio_provider.dart';
import 'package:manos_a_la_obra/src/providers/solicitud_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class TarjetaPedidosWidget extends StatefulWidget {
  final descripcion;
  final estado;
  final fechaInicio;
  final image;
  final nombreServicio;
  TarjetaPedidosWidget({
    Key key,
    @required this.descripcion,
    @required this.estado,
    @required this.fechaInicio,
    @required this.image,
    @required this.nombreServicio,
  }) : super(key: key);

  @override
  _TarjetaPedidosWidgetState createState() => _TarjetaPedidosWidgetState();
}

class _TarjetaPedidosWidgetState extends State<TarjetaPedidosWidget> {
  final providerServicio = SolicitudDataProvider();
  String imgUrl;

  @override
  Widget build(BuildContext context) {
    _obtenerUrlImagen(widget.image);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          //callback();
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: widget.estado
                    ? Colors.greenAccent.withOpacity(0.9)
                    : Colors.redAccent.withOpacity(0.8),
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
                      aspectRatio: 2,
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
                                      widget.nombreServicio,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Row(
                                        children: <Widget>[
                                          widget.estado
                                              ? Text(
                                                  "Aceptado",
                                                  style: TextStyle(
                                                      color: Colors.green),
                                                )
                                              : Text(
                                                  "Esperando Aprobación",
                                                  style: TextStyle(
                                                      color: Colors.redAccent),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16, top: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  timeago
                                      .format(widget.fechaInicio.toDate(),
                                          locale: 'es')
                                      .toString(),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
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
    final providerServicio = ServicioDataProvider();
    final fileURL = await providerServicio.getImageServicio(widget.image);
    if (this.mounted) {
      setState(() {
        imgUrl = fileURL;
      });
    }
  }
}
