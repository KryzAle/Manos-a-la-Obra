import 'package:flutter/material.dart';
import 'package:manos_a_la_obra/src/bloc/provider.dart';
import 'package:manos_a_la_obra/src/widgets/cardCategoriaServicio_widget.dart';
class InicioPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  final categoriaBloc = Provider.categoria(context);
  categoriaBloc.cargarCategoria();
    return Container(
      child: Column(
        children: <Widget>[
          _crearSearch(context),
          SizedBox(height: 80.0,),
          StreamBuilder(
            stream:  categoriaBloc.getCategoria,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot){
              if(snapshot.hasData){
                return CardCateriaServicio(lista: snapshot.data);
              }else{
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          
        ],
      ),
    );
  }
}

Widget _crearSearch(BuildContext context) {
  final _screenSize = MediaQuery.of(context).size;
   return Container(
      width: _screenSize.width *0.60,
      height: 35.0,
      child: TextField(
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0)
          ),
          hintText: 'Que necesitas?',
          contentPadding: EdgeInsets.only(top:5.0,right: 40.0),
          prefixIcon: Icon(Icons.search),
        ),
        onTap: (){
          // showSearch(context: null, delegate: null)
        },
      ),
    );
}