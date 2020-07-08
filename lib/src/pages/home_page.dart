import 'package:flutter/material.dart';
import 'package:manos_a_la_obra/src/bloc/provider.dart';
import 'package:manos_a_la_obra/src/pages/home_page_inicio.dart';
import 'package:manos_a_la_obra/src/pages/solicitudes_page.dart';
import 'package:manos_a_la_obra/src/providers/user_data_provider.dart';
import 'package:manos_a_la_obra/src/widgets/alert_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
  static TextStyle textStyle = TextStyle(color: Colors.black);
  List<Widget> _widgetOpciones = <Widget>[
    Text('pedidos'),
    InicioPage(),
    SolicitudesPage(),
    //AlertSolicitudes(),
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
          leading: _crearPerfil(context),
          title: _homeOptions.elementAt(_selectedIndex),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
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

  Widget _crearPerfil(BuildContext context) {
    final loginbloc = Provider.of(context);
    return IconButton(
      icon: Icon(
        Icons.account_circle,
        color: Colors.deepOrangeAccent,
      ),
      onPressed: () {
        Navigator.pushReplacementNamed(context, 'welcome');
        loginbloc.logOut();
        loginbloc.restarValues();
      },
      iconSize: 40.0,
    );
  }

  List<BottomNavigationBarItem> _obtenerItems() {
    return <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.assignment),
        title: Text('Pedidos'),
      ),
      BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Inicio')),
      BottomNavigationBarItem(
          icon: Icon(Icons.work), title: Text('Solicitudes')),
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
