import 'package:flutter/material.dart';
import 'package:manos_a_la_obra/src/providers/servicio_provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class TarjetaWidget extends StatefulWidget {
  final String categoria;
  final String descripcion;
  final String nombre;
  final String disponibilidad;
  final String path;

  TarjetaWidget(
      {@required this.categoria,
      this.descripcion,
      this.nombre,
      this.disponibilidad,
      this.path});

  @override
  _TarjetaWidgetState createState() => _TarjetaWidgetState();
}

class _TarjetaWidgetState extends State<TarjetaWidget> {
  String imgUrl;
  @override
  Widget build(BuildContext context) {
    _obtenerUrlImagen(widget.path);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          //callback();
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
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
                                      widget.nombre,
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
                                          SmoothStarRating(
                                            allowHalfRating: true,
                                            starCount: 5,
                                            rating: 4.5,
                                            size: 20,
                                            color: Colors.orange,
                                            borderColor: Colors.yellow,
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
                                  widget.categoria,
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
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(32.0),
                    ),
                    child: InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.close,
                          color: Colors.deepOrange,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /*_obtenerUrlImagen(path) {
    StorageReference ref = FirebaseStorage.instance.ref().child(path);
    ref.getDownloadURL().then((fileURL) {
      if (this.mounted) {
        setState(() {
          imgUrl = fileURL;
        });
      }
    });
  }*/

  _obtenerUrlImagen(path) async {
    final providerServicio = ServicioDataProvider();
    final fileURL = await providerServicio.getImageServicio(widget.path);
    if (this.mounted) {
      setState(() {
        imgUrl = fileURL;
      });
    }
  }
}
