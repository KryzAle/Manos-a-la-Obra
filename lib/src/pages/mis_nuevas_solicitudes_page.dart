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
                    if(snapshot.data.isNotEmpty){
                      return CardNuevaSolicitud(lista: snapshot.data);
                    }
                    else{
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 50,),
                          Image(image: NetworkImage('https://www.generadormemes.com/media/created/1lww28xpr7hodxdgmk92d28e0v5dh9wph358znp2g48ep5e8n3eabu1dqu5tsvq.jpg')),
                        ],
                      );
                    }
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
