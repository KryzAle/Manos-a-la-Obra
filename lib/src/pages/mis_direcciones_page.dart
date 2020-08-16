import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:manos_a_la_obra/src/bloc/provider.dart';
import 'package:manos_a_la_obra/src/models/direccion_model.dart';
import 'package:manos_a_la_obra/src/providers/direccion_provider.dart';

class MisDireccionesPage extends StatelessWidget {
  const MisDireccionesPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final direccionBloc = Provider.direccion(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Direcciones',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        leading: GestureDetector(
          child: Icon(Icons.cancel, color: Colors.white,),
          onTap: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          InkWell(
            onTap: (){
              Navigator.pushNamed(context, 'map',arguments: false);

            },
            child: _crearBoton('Nueva Direccion',Icons.place)
          ),

          InkWell(
            onTap: ()async{
              try {
                final position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                final ubicacion = await transformarUbicacion(position);
                final direccion = Direccion(latitud: position.latitude,longitud: position.longitude,ubicacionMap: ubicacion.name);
                Navigator.pushNamed(context, 'form_direccion',arguments: direccion);
              } on Exception {
              }
            },
            child: _crearBoton('Ubicacion Actual',Icons.near_me)
          ),
          Container(
            margin: EdgeInsets.all(30.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black26)
              )
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text('Mis Direcciones : ',style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0
            ),)
          ),
          StreamBuilder(
            stream: direccionBloc.getDireccion ,
            builder: (BuildContext context, AsyncSnapshot<List<Direccion>> snapshot){
              if(snapshot.hasData){
                return Column(
                  children: _crearDireccionesLista(context,snapshot.data),
                );
              }else{
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _crearBoton(String texto, IconData iconData) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 20.0),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(10.0)
      ),
      margin: EdgeInsets.only(top:20.0, right: 20.0,left: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(texto, style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
          ),),
          Icon(iconData, color: Colors.deepOrangeAccent,)
        ],
      ),
    );
  }

  Widget _crearDirecciones(BuildContext context,Direccion direccion) {
    return Container(
      margin: EdgeInsets.all(20.0),
      padding: EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black26)
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.place, color: Colors.black38),
          SizedBox(width: 20.0,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(direccion.nombre),
              Text('${direccion.callePrincipal} ${direccion.numeroVivienda} y  ${direccion.calleSecundaria}'),
              Text(direccion.referencia),
            ],
          ),
          Expanded(child: Container()),
          PopupMenuButton(
            onSelected: (value){
              choiceAction(value,direccion,context);
            },
            itemBuilder: (BuildContext context){
              return [
                PopupMenuItem(child: Text('Editar'), value: 'Editar',),
                PopupMenuItem(child: Text('Eliminar'), value: 'Eliminar',),
              ];
            },
          )
        ],
      ),
    );
  }

  choiceAction(String value,Direccion direccion,BuildContext context) {
    final direccionProvider = DireccionProvider();
    switch (value) {
      case 'Editar':
      final newDireccion = Direccion.clone(direccion);
        Navigator.pushNamed(context, 'form_direccion',arguments: newDireccion);
        break;
      case 'Eliminar':
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Icon(Icons.delete_outline,size: 50.0,),
              content: Text("¿Estas seguro que deseas eliminar esta direccion?"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Cancelar',style: TextStyle(color: Colors.black38),),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('Aceptar'),
                  onPressed: () {
                    direccionProvider
                        .deleteDireccion(direccion.id);
                    Navigator.of(context).pop();
                  },
                ),
              ]);
        });
        break;
    }
  }

  List<Widget> _crearDireccionesLista(BuildContext context,List<Direccion> direcciones) {
    List<Widget> widgets = List();
    direcciones.map((value) {
      widgets.add(_crearDirecciones(context, value));
    }).toList();
    return widgets;
  }
  Future<Placemark> transformarUbicacion(Position position) async{
      final ubicacion = await Geolocator().placemarkFromCoordinates(position.latitude,position.longitude);
      return ubicacion[0];
  }

}