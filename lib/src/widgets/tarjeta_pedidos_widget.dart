import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manos_a_la_obra/src/providers/solicitud_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class TarjetaPedidosWidget extends StatefulWidget {
  final descripcion;
  final estado;
  final fechaInicio;
  TarjetaPedidosWidget({
    Key key,
    @required this.descripcion,
    @required this.estado,
    @required this.fechaInicio,
  }) : super(key: key);

  @override
  _TarjetaPedidosWidgetState createState() => _TarjetaPedidosWidgetState();
}

class _TarjetaPedidosWidgetState extends State<TarjetaPedidosWidget> {
  final providerServicio = SolicitudDataProvider();

  @override
  Widget build(BuildContext context) {
    DateTime myDateTime =
        DateTime.parse(widget.fechaInicio.toDate().toString());
    String formattedDateTime =
        DateFormat('yyyy-MM-dd – kk:mm').format(myDateTime);

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
                      aspectRatio: 2,
                      child: Image.network(
                        "https://3.bp.blogspot.com/-ByRv-09pFwQ/WH-El7nWQSI/AAAAAAAAA_w/IEDG-0vPM5grtqPuU44LbWm1qAKuZgc-QCLcB/s1600/0001_7.jpg",
                        fit: BoxFit.cover,
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
                                      widget.descripcion,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 22,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Row(
                                        children: <Widget>[
                                          Text("Esperando Aprobación")
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
                                  /*timeago
                                      .format(widget.fechaInicio.toDate(),
                                          locale: 'es')
                                      .toString(),*/
                                  formattedDateTime,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22,
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
}
