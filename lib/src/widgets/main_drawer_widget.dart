import 'package:flutter/material.dart';
import 'package:manos_a_la_obra/src/bloc/provider.dart';
import 'package:manos_a_la_obra/src/models/usuario_model.dart';

class MainDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final loginbloc = Provider.of(context);
    final userBloc = Provider.usuario(context);
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            color: Theme.of(context).primaryColor,
            child: StreamBuilder(
              stream: userBloc.getUsuario ,
              builder: (BuildContext context, AsyncSnapshot<Usuario> snapshot){
                if (snapshot.hasData) {
                  return Center(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 30),
                          child:  Hero(
                            tag: snapshot.data.nombre,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child:  FadeInImage(
                                    image: NetworkImage('https://kryzale.files.wordpress.com/2019/03/10928983_1386324075004590_3936503588471348202_n.jpg?w=960&h=730&crop=1'),
                                    fit: BoxFit.cover,
                                    placeholder: AssetImage('assets/rol.gif'),
                                  ),
                              ),
                          ),
                        ),
                        Text(
                          snapshot.data.nombre, 
                          style:  Theme.of(context).textTheme.subtitle1,
                        )
                      ],
                    ),
                  );
                }else{
                  return Container();
                }
              },
            ),
          ),
          ListTile(
            title: Text('Mi Perfil'),
            leading: Icon(Icons.person_outline),
            onTap: (){
              Navigator.pushNamed(context, 'perfil');
            },
          ),
          ListTile(
            title: Text('Ayuda'),
            leading: Icon(Icons.help_outline),
          ),
          ListTile(
            title: Text('Cerrar Sesión'),
            leading: Icon(Icons.exit_to_app),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, 'welcome');
              userBloc.logout();
              loginbloc.logOut();
            },
          )
        ],
      ),
    );
  }
}