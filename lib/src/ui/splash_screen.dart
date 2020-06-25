import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '¡Bienvenido!',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0  
              ),
              textAlign: TextAlign.center,
            ),
            _crearImagen(),
          ],
        ),
        color: Colors.white,
      ),
    );
  }

  Widget _crearImagen() {
    return ClipRRect(
      child: Image(image: AssetImage('assets/rol.gif')),
      borderRadius: BorderRadius.circular(20.0),
    );
  }
}