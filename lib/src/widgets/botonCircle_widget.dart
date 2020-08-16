import 'package:flutter/material.dart';

class ButtonCircle extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String texto;

  ButtonCircle({@required this.icon, this.color, this.texto});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105,
      width: 120,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
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
          SizedBox(height: 5.0,),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(100),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 40.0,
              color: Colors.black,
            ),
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
