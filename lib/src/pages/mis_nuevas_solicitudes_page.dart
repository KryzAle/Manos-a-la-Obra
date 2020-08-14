import 'package:flutter/material.dart';
import 'package:manos_a_la_obra/src/bloc/provider.dart';
import 'package:manos_a_la_obra/src/widgets/cardNuevaSolicitud_widget.dart';

class MisNuevasSolicitudesPage extends StatelessWidget {
  const MisNuevasSolicitudesPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pedidoUsuario = Provider.solicitud(context);
    final _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Nuevas Solicitudes"),
        centerTitle: true,
      ),
      body: Container(
        height: _screenSize.height,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder(
                stream: pedidoUsuario.getNuevasSolicitudes,
                builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                  if (snapshot.hasData) {
                    return CardNuevaSolicitud(lista: snapshot.data);
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
