import 'package:flutter/material.dart';
import 'package:manos_a_la_obra/src/models/solicitud_model.dart';
import 'package:manos_a_la_obra/src/providers/solicitud_provider.dart';
import 'package:manos_a_la_obra/src/widgets/item_solicitud_box.dart';

import 'item_header_diagonal.dart';

class SolicitudDetalleHeader extends StatefulWidget {
  SolicitudDetalleHeader(this.solicitud, this.cliente);

  final Solicitud solicitud;
  final cliente;

  @override
  _SolicitudDetalleHeaderState createState() => _SolicitudDetalleHeaderState();
}

class _SolicitudDetalleHeaderState extends State<SolicitudDetalleHeader> {
  String imgUrl;
  @override
  Widget build(BuildContext context) {
    _obtenerUrlImagen(widget.solicitud.servicio["evidencia"]);

    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 150),
          child: _buildDiagonalImageBackground(context),
        ),
        Positioned(
          top: 26,
          left: 4,
          child: BackButton(color: Colors.white),
        ),
        Positioned(
          bottom: 0,
          left: 16,
          right: 16,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Hero(
                  tag: widget.solicitud.fechaInicio.toString(),
                  child: SolicitudBoxItem(
                    context,
                    widget.solicitud,
                    true,
                  )),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        !widget.cliente
                            ? widget.solicitud.cliente["nombre"]
                            : widget.solicitud.proveedor["nombre"],
                        style: Theme.of(context).textTheme.headline6,
                        maxLines: 3,
                        overflow: TextOverflow.fade,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Row(
                          children: [
                            !widget.cliente
                                ? OutlineButton(
                                    onPressed: () => {},
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.location_on,
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline2
                                              .color,
                                        ),
                                        Text("Ruta",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6),
                                      ],
                                    ),
                                    padding:
                                        const EdgeInsets.fromLTRB(6, 0, 12, 0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    borderSide: BorderSide(
                                        color: Colors.black54, width: 2),
                                    highlightColor: Colors.white70,
                                    splashColor: Colors.black12,
                                    highlightElevation: 0,
                                  )
                                : SizedBox(width: 1),
                            Padding(padding: EdgeInsets.only(left: 8)),
                            OutlineButton(
                              onPressed: () => {},
                              child: Row(
                                children: <Widget>[
                                  Image(
                                    image: AssetImage('assets/whatsapp.png'),
                                    width: 30,
                                  )
                                ],
                              ),
                              padding: const EdgeInsets.fromLTRB(6, 0, 12, 0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              borderSide:
                                  BorderSide(color: Colors.black54, width: 2),
                              highlightColor: Colors.white70,
                              splashColor: Colors.black12,
                              highlightElevation: 0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDiagonalImageBackground(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return DiagonallyCutColoredImage(
      /*FadeInImage.assetNetwork(
        image: imgUrl,
        placeholder: "assets/placeholder_cover.jpg",
        width: screenWidth,
        height: 260,
        fit: BoxFit.cover,
      ),*/
      imgUrl != null
          ? FadeInImage.assetNetwork(
              placeholder: "assets/placeholder_cover.jpg",
              image: imgUrl,
              fit: BoxFit.cover,
              width: screenWidth,
              height: 260,
            )
          : null,
      color: const Color(0x00FFFFFF),
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
}
