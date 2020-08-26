import 'package:flutter/material.dart';
import 'package:manos_a_la_obra/src/models/solicitud_model.dart';
import 'package:manos_a_la_obra/src/providers/solicitud_provider.dart';

class SolicitudBoxItem extends StatefulWidget {
  static const IMAGE_RATIO = 1.50;

  SolicitudBoxItem(this.buildContext, this.solicitud, {this.width = 120});
  final BuildContext buildContext;
  final Solicitud solicitud;
  final double width;

  @override
  _SolicitudBoxItemState createState() => _SolicitudBoxItemState();
}

class _SolicitudBoxItemState extends State<SolicitudBoxItem> {
  String imgUrl;

  @override
  Widget build(BuildContext context) {
    _obtenerUrlImagen(widget.solicitud.cliente["foto"]);

    double height = 150;

    return Material(
      borderRadius: BorderRadius.circular(20.0),
      clipBehavior: Clip.hardEdge,
      elevation: 8,
      shadowColor: Color(0xCC000000),
      child:
          /*FadeInImage.assetNetwork(
        image: imgUrl,
        placeholder: "assets/placeholder_cover.jpg",
        width: widget.width,
        height: height,
        fit: BoxFit.cover,
      ),*/
          imgUrl != null
              ? Image.network(
                  imgUrl,
                  fit: BoxFit.cover,
                  width: widget.width,
                  height: height,
                )
              : null,
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
