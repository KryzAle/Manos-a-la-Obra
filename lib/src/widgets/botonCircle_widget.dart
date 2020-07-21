import 'package:flutter/material.dart';

class ButtonCircle extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String texto;

  ButtonCircle({@required this.icon, this.color, this.texto});
  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Container(
      height: _screenSize.height * 0.12,
      width: _screenSize.width * 0.27,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: color,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              spreadRadius: 2.0,
              offset: Offset(2.0, 10.0),
            )
          ]),
      child: ClipRRect(
        child: crearCard(context),
      ),
    );
  }

  Widget crearCard(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Icon(
            icon,
            size: 40.0,
          ),
          Container(
            child: Text(
              texto,
              textAlign: TextAlign.center,
            ),
            padding: EdgeInsets.all(10.0),
          ),
        ],
      ),
    );
  }
}
