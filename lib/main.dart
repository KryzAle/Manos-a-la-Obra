import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manos_a_la_obra/src/bloc/provider.dart';
import 'package:manos_a_la_obra/src/providers/usuario_provider.dart';
import 'package:manos_a_la_obra/src/routes/routes.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final provider = new UsuarioProvider();
  final user = await provider.isSignedIn();
  String ruta = user ? 'home' : 'welcome';
  runApp(MyApp(ruta: ruta,));
} 
  
 
class MyApp extends StatelessWidget {
  final String ruta;
  MyApp({this.ruta});
  final provider = UsuarioProvider();
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Provider(
        child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.orangeAccent ,
          primarySwatch: Colors.orange,
          textTheme:GoogleFonts.latoTextTheme(textTheme).copyWith(
            bodyText1: GoogleFonts.montserrat(textStyle: textTheme.bodyText1),
          ),
        ),
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        initialRoute: ruta,
        routes: getAplicationRoutes(),
        
      ),
    );
  }
}