import 'package:flutter/material.dart';
import 'package:manos_a_la_obra/src/pages/home_page_inicio.dart';
import 'package:manos_a_la_obra/src/pages/mis_pedidos_page.dart';
import 'package:manos_a_la_obra/src/pages/solicitudes_page.dart';
import 'package:manos_a_la_obra/src/widgets/main_drawer_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
  static TextStyle textStyle = TextStyle(color: Colors.black);
  List<Widget> _widgetOpciones = <Widget>[
    MisPedidosPage(),
    InicioPage(),
    SolicitudesPage(),
  ];
  List<Widget> _homeOptions = <Widget>[
    Text(
      'Pedidos',
      style: textStyle,
    ),
    Text(
      'Hola',
      style: textStyle,
    ),
    Text(
      'Solicitudes',
      style: textStyle,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          leading: _crearPerfil(),
          title: _homeOptions.elementAt(_selectedIndex),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        drawer: MainDrawer(),
        body: _agregarBody(),
        bottomNavigationBar: BottomNavigationBar(
          items: _obtenerItems(),
          backgroundColor: Colors.deepOrangeAccent,
          selectedItemColor: Colors.white,
          currentIndex: _selectedIndex,
          onTap: _moveIndex,
        ),
      ),
    );
  }

  Widget _crearPerfil() {
    return Builder(
      builder: (context) {
        return IconButton(
          icon: Icon(
            Icons.account_circle,
            color: Colors.deepOrangeAccent,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          iconSize: 40.0,
        );
      },
    );
  }

  List<BottomNavigationBarItem> _obtenerItems() {
    return <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.assignment),
        title: Text('Pedidos'),
      ),
      BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Inicio')),
      BottomNavigationBarItem(icon: Icon(Icons.work), title: Text('Trabajos')),
    ];
  }

  Widget _agregarBody() {
    return Center(
      child: _widgetOpciones.elementAt(_selectedIndex),
    );
  }

  void _moveIndex(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }
}
