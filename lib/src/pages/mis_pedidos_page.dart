import 'package:flutter/material.dart';
import 'package:manos_a_la_obra/src/bloc/provider.dart';
import 'package:manos_a_la_obra/src/widgets/cardpedido_widget.dart';

class MisPedidosPage extends StatelessWidget {
  const MisPedidosPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pedidoUsuario = Provider.solicitud(context);
    final _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: _screenSize.height,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder(
                stream: pedidoUsuario.getSolicitudesUsuario,
                builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                  if (snapshot.hasData) {
                    return CardPedido(lista: snapshot.data);
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
