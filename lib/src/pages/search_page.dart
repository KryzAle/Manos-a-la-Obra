import 'package:flutter/material.dart';
import 'package:manos_a_la_obra/src/bloc/provider.dart';
import 'package:manos_a_la_obra/src/models/servicio_model.dart';
import 'package:manos_a_la_obra/src/pages/detalle_servicio_page.dart';
class SearchPage extends StatefulWidget {
  const SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  double _currentSliderValue = 0;
  List<bool> isSelected = List.generate(3, (_) => false);
  List<String> filtros = ['puntuacion','disponibilidad','popularidad'];
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 30.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:BorderRadius.circular(40),
          ),
          child: TextField(
            onChanged: (value){
              _filtrar(value,context);
            },
            autofocus: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Que necesitas?',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: Icon(Icons.filter_list, color: Colors.white,),
              onTap: (){
                _mostrarBottomSheet(context);
              },
            ),
          )
        ],
        centerTitle: false,
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_ios, color: Colors.white,),
          onTap: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: _crearLista(context),
    );
  }

  _mostrarBottomSheet(BuildContext context){
    final _servicioBloc = Provider.servicio(context);
    final style = TextStyle(fontSize: 16.0);
    showModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (context){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    child: Text('Limpiar'),
                  ),
                  Text('Filtros',style: TextStyle(fontWeight: FontWeight.bold),),
                  InkWell(
                    child: Text('Hecho'),
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            ),
            Divider(color: Colors.grey,),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                child: ListView(
                  children: <Widget>[
                    Text('Distancia',style: style,),
                    SizedBox(height: 5.0,),
                    StatefulBuilder(
                      builder: (context, setState){
                        return Slider(
                        value: _currentSliderValue,
                        min: 0,
                        max: 200,
                        divisions: 5,
                        label: _currentSliderValue.round().toString()+'m',
                        onChanged: (double value) {
                          setState(() {
                            _currentSliderValue = value;
                          });
                        });
                      }
                    ),
                    Text('Ordenar Por',style: style,),
                    SizedBox(height: 5.0,),
                    StatefulBuilder(
                      builder: (context, setState){
                        return ToggleButtons(
                          constraints: BoxConstraints(
                            minHeight: 50,
                            minWidth: 120,
                          ),
                          children: [
                            Text('Puntuacion'),
                            Text('Disponibilidad'),
                            Text('Popularidad'),
                          ], 
                          onPressed: (int index) {
                            setState(() {
                              for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
                                if (buttonIndex == index) {
                                  isSelected[buttonIndex] = true;
                                  print(filtros[buttonIndex]);
                                _servicioBloc.filtrarServiciosFiltros(filtros[buttonIndex]);
                                } else {
                                  isSelected[buttonIndex] = false;
                                }

                              }
                            });
                          },
                          isSelected: isSelected,
                        );
                      }
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }
    );
  }

  List<Widget> _crearPuntaje(double starts) {
    final widgets = <Widget>[];
    int numeroStrella = starts.toInt();
    if (numeroStrella > 0) {
      for (var i = 0; i < numeroStrella; i++) {
        widgets.add(Icon(
          Icons.star,
          color: Colors.orangeAccent,
        ));
      }
      widgets.add(starts - numeroStrella != 0
          ? Icon(
              Icons.star_half,
              color: Colors.orangeAccent,
            )
          : null);
    } else {
      widgets.add(Text('Sin Puntuacion'));
    }
    return widgets;
  }

  Widget _crearLista(BuildContext context) {
    final _servicioBloc = Provider.servicio(context);
    return StreamBuilder(
        stream: _servicioBloc.getServiciosSearch,
        builder:
            (BuildContext context, AsyncSnapshot<List<Servicio>> snapshot) {
          if (snapshot.hasData) {
            return ListView(
                children: snapshot.data.map((servicio) {
                return ListTile(
                  title: Text(
                    servicio.nombre.toUpperCase(),
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  subtitle: Row(
                    children: _crearPuntaje(servicio.puntaje),
                  ),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://www.christiangarces.org/wp-content/uploads/2017/11/perfil-profesional.jpg'),
                  ),
                  trailing: Icon(Icons.arrow_right),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetalleServicio(
                            categoria: servicio.categoria,
                            descripcion: servicio.descripcion,
                            nombre: servicio.nombre,
                            disponibilidad: servicio.disponibilidad,
                            evidencia: servicio.evidencia,
                            puntajes: servicio.puntaje,
                            idServicio: servicio.id,
                            idUsuario: servicio.idUsuario,
                          ),
                        ));
                  },
                );
            }).toList());
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
  }

  _filtrar(String query, BuildContext context){
    final _servicioBloc = Provider.servicio(context);

    _servicioBloc.filtrarServiciosQuery(query);
  }
}
